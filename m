Return-Path: <linux-kernel-owner+w=401wt.eu-S936486AbXFFWyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936486AbXFFWyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934884AbXFFWyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:54:39 -0400
Received: from lucidpixels.com ([75.144.35.66]:36515 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764852AbXFFWyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:54:38 -0400
Date: Wed, 6 Jun 2007 18:54:37 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <20070606153737.2c9da784.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0706061852590.2716@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
 <200706061524.52628.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061826260.5415@p34.internal.lan>
 <200706061528.44070.jesse.barnes@intel.com> <20070606153737.2c9da784.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jun 2007, Randy Dunlap wrote:

> On Wed, 6 Jun 2007 15:28:43 -0700 Jesse Barnes wrote:
>
>> On Wednesday, June 6, 2007 3:26 pm Justin Piszcz wrote:
>>> Nope, I booted with only netconsole= options.  I have a lot of HW in
>>> the box and I guess the buffer is too small.  Not sure where to
>>> change it in the kernel.  Looking..
>>
>> It's called "kernel log buffer size" and it's in "General setup".
>
> or you can just boot with "log_buf_len=256k" on the kernel boot line (e.g.)
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>

Hm, not sure if it was from the patch or what but I ran this:

1. swapoff -a
2. ./eatmem

The machine responded to ping and alt-sysrq-b but the box remain 
unresponsive, I guess the kernel did not kill the process? :(

The moments before it 'froze'

top - 18:48:01 up 15 min,  7 users,  load average: 6.61, 18.50, 13.31
Tasks: 200 total,  18 running, 182 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us, 90.7%sy,  0.0%ni,  5.9%id,  3.3%wa,  0.0%hi,  0.0%si, 
0.0%st
Mem:   8039576k total,  7998860k used,    40716k free,        8k buffers
Swap:        0k total,        0k used,        0k free,     1664k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
   248 root      11  -5     0    0    0 R   85  0.0   0:16.05 kswapd0
  2265 nut       18   0 13320  244    4 R   40  0.0   0:03.13 newhidups
  2267 nut       18   0 12216  168    4 R   40  0.0   0:02.04 upsd
  2474 ntp       18   0 22192  400    8 R   39  0.0   0:02.00 ntpd
  3563 jpiszcz   18   0 41964 1264    4 R   38  0.0   0:02.20 pine
  3530 root      18   0 96240 3132   36 R   37  0.0   0:02.09 kdm_greet
  2052 root      18   0  6080  112    4 R   37  0.0   0:02.00 hald-addon-stor
  4479 war       17   0 18012  700  252 R   33  0.0   0:01.81 top
  4480 war       19   0 6948m 6.8g    4 R   22 88.4   0:05.81 eatmem
  2095 root      18   0 13128  216    8 R   10  0.0   0:00.50 dirmngr
  2545 root      18   0 95788 2488    4 R    5  0.0   0:00.25 apache2
  3564 war       18   0 41620  832    4 R    5  0.0   0:00.34 pine
  2270 nut       15   0 12212  144    4 S    1  0.0   0:00.05 upsmon
   561 root      10  -5     0    0    0 S    0  0.0   0:00.02 xfsbufd

Very simply program:

#include <iostream>
using namespace std;

int main()
{
   long int interations = 10000000;
   int counter = 1;

   for(counter;counter<interations;counter++)
   {
      double *d = new double[100];
   }

   return 0;
}

Any idea why the OOM killer can or does not kill it?

Justin.

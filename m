Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbZFHRWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbZFHRWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbZFHRUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:20:20 -0400
Received: from fmailhost06.isp.att.net ([204.127.217.106]:33955 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbZFHRUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:20:19 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A2D484F.3090209@lwfinger.net>
Date: Mon, 08 Jun 2009 12:20:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>	<D9VoutSOyXP.A.hvH.Ha7KKB@chimera>	<4A2BBC30.2030300@lwfinger.net>	<84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>	<4A2BCC6F.8090004@redhat.com>	<84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>	<4A2BEC4F.6020908@lwfinger.net> <20090608173219.0588af26.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090608173219.0588af26.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Sun, 07 Jun 2009 11:35:27 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> Pekka Enberg wrote:
>>> On Sun, Jun 7, 2009 at 5:19 PM, Rik van Riel <riel@redhat.com> wrote:
>>>> That is a very strange trace.  The Mem-Info indicates
>>>> that the system has more than enough memory free, and
>>>> also enough memory in higher-order free blocks.
>>>>
>>>> This would indicate a bug somewhere in the page
>>>> allocator - this memory should have been given to this
>>>> allocation request.
>>> Aha, I always have difficulties deciphering the traces. But lets
>>> invite Mel to the party then!
>> I'm happy to see some action on this problem. As usual, I'm happy to
>> test patches and/or provide diagnostic output.
>>
> One question. 
> 
> Did your system fragmented in same way as to this
> (see DMA32, 10052 of order-0 pages) in older kernel ? I think you can check
> fragmentation status via /proc/buddyinfo.
> =
> kernel: Node 0 DMA: 3*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
> 1*1024kB 0*2048kB 0*4096kB = 2100kB
> kernel: Node 0 DMA32: 10062*4kB 1*8kB 1*16kB 0*32kB 1*64kB 1*128kB 0*256kB
> 1*512kB 0*1024kB 0*2048kB 0*4096kB = 40976kB
> ==

The current system has not been up very long and does not show the
fragmentation:

finger@larrylap:~/wireless-testing> cat /proc/buddyinfo
Node 0, zone      DMA      4      5      4      2      4      1      2
     0      1      0      0
Node 0, zone    DMA32    261     78     46     55     61     54     37
    17     14     12    262

After I did a git pull and a kernel build with the sources on an
NFS-mounted volume, the fragmentation increased:

Node 0, zone      DMA      4      5      4      2      4      1      2
     0      1      0      0
Node 0, zone    DMA32   2213   1924   1292    705    285     81     25
     8      5      4    141

After a git pull and a kernel build on a second NFS-mounted tree:

Node 0, zone      DMA      4      5      4      2      4      1      2
     0      1      0      0
Node 0, zone    DMA32   3127   3058   1989    756    401    142     56
    14      5      3     12

Larry

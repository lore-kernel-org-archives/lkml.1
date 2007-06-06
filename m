Return-Path: <linux-kernel-owner+w=401wt.eu-S965353AbXFFWjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965353AbXFFWjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936604AbXFFWjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:39:19 -0400
Received: from lucidpixels.com ([75.144.35.66]:50546 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936537AbXFFWjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:39:17 -0400
Date: Wed, 6 Jun 2007 18:39:16 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706061528.44070.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0706061838200.3563@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
 <200706061524.52628.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061826260.5415@p34.internal.lan>
 <200706061528.44070.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jun 2007, Jesse Barnes wrote:

> On Wednesday, June 6, 2007 3:26 pm Justin Piszcz wrote:
>> Nope, I booted with only netconsole= options.  I have a lot of HW in
>> the box and I guess the buffer is too small.  Not sure where to
>> change it in the kernel.  Looking..
>
> It's called "kernel log buffer size" and it's in "General setup".
>
> Jesse
>

Seems stable & fast so far, except when it hit swap :)

top - 18:38:13 up 5 min,  6 users,  load average: 38.56, 12.65, 4.52
Tasks: 227 total,  64 running, 163 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us, 23.9%sy,  0.0%ni,  0.0%id, 72.7%wa,  0.0%hi,  3.4%si,  0.0%st
Cpu1  :  0.0%us, 23.5%sy,  0.0%ni,  1.0%id, 75.5%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu2  :  0.0%us, 24.1%sy,  0.0%ni,  0.0%id, 75.9%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu3  :  0.0%us, 23.6%sy,  0.0%ni,  0.0%id, 76.4%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   8039576k total,  7998988k used,    40588k free,       12k buffers
Swap: 16787768k total,   879324k used, 15908444k free,    16316k cached

Tested with
$ stress --vm 32 --vm-bytes 250M
and
$ stress --vm 64 --vm-bytes 250M

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
   248 root      10  -5     0    0    0 D   18  0.0   0:07.81 kswapd0
  3788 war       18   0  256m 115m  164 D    3  1.5   0:01.32 stress
  3800 war       18   0  256m 7300  160 R    3  0.1   0:00.58 stress
  3801 war       18   0  256m  34m  160 R    3  0.4   0:02.48 stress
  3808 war       18   0  256m 217m  164 R    3  2.8   0:01.16 stress
   559 root      10  -5     0    0    0 D    2  0.0   0:00.15 md0_raid1
  3771 war       18   0  256m 174m  164 R    2  2.2   0:01.30 stress
  3785 war       18   0  256m  30m  164 R    2  0.4   0:01.42 stress
  3813 war       18   0  256m  34m  164 R    2  0.4   0:01.06 stress
  3787 war       18   0  256m  24m  160 R    2  0.3   0:00.25 stress
  3794 war       18   0  256m  40m  160 R    2  0.5   0:00.14 stress
  3778 war       18   0  256m 109m  164 R    2  1.4   0:01.23 stress
  3783 war       18   0  256m 185m  164 R    2  2.4   0:01.29 stress
  3799 war       18   0  256m 172m  164 R    2  2.2   0:01.07 stress
  3816 war       18   0  256m 203m  160 R    2  2.6   0:00.39 stress
  3819 war       18   0  256m 144m  160 R    2  1.8   0:00.40 stress
  3820 war       18   0  256m 147m  160 R    2  1.9   0:00.39 stress
  3825 war       18   0  256m  91m  164 R    2  1.2   0:01.16 stress
  3777 war       18   0  256m  29m  164 R    1  0.4   0:01.05 stress
  3779 war       18   0  256m 197m  164 R    1  2.5   0:01.29 stress
  3805 war       18   0  256m 216m  160 R    1  2.8   0:00.36 stress
  3812 war       18   0  256m  30m  164 R    1  0.4   0:01.14 stress
  3830 war       18   0  256m 176m  164 R    1  2.3   0:01.17 stress
  3831 war       18   0  256m  64m  164 R    1  0.8   0:01.40 stress
  3769 war       18   0  256m  43m  164 R    1  0.6   0:01.23 stress
  3770 war       18   0  256m 169m  164 R    1  2.2   0:01.18 stress
  3773 war       18   0  256m  44m  160 R    1  0.6   0:00.29 stress
  3774 war       18   0  256m  21m  160 R    1  0.3   0:00.21 stress
  3780 war       18   0  256m 167m  164 R    1  2.1   0:01.33 stress
  3781 war       18   0  256m 143m  164 R    1  1.8   0:01.35 stress
  3798 war       18   0  256m 153m  164 R    1  1.9   0:01.16 stress
  3807 war       18   0  256m  31m  164 R    1  0.4   0:01.17 stress
  3817 war       18   0  256m 185m  160 R    1  2.4   0:00.40 stress
  3822 war       18   0  256m 200m  160 R    1  2.6   0:00.41 stress
  3824 war       18   0  256m 8684  160 R    1  0.1   0:00.16 stress
  3827 war       18   0  256m 103m  164 R    1  1.3   0:00.95 stress
  3828 war       18   0  256m 1976  160 R    1  0.0   0:00.19 stress
  2026 daemon    30  15 30580  436  372 D    1  0.0   0:02.10 bindgraph.pl
  3768 war       18   0  256m  81m  164 R    1  1.0   0:01.84 stress
  3772 war       18   0  256m 158m  164 R    1  2.0   0:01.11 stress
  3782 war       18   0  256m 180m  164 R    1  2.3   0:01.25 stress
  3786 war       18   0  256m 173m  164 R    1  2.2   0:01.13 stress
  3790 war       18   0  256m  20m  164 R    1  0.3   0:01.10 stress
  3791 war       18   0  256m  36m  164 R    1  0.5   0:01.80 stress
  3796 war       18   0  256m 111m  164 R    1  1.4   0:01.04 stress
  3797 war       18   0  256m 120m  164 R    1  1.5   0:01.12 stress
  3803 war       18   0  256m 129m  160 R    1  1.6   0:01.98 stress
  3804 war       18   0  256m 234m  160 R    1  3.0   0:00.40 stress
  3806 war       18   0  256m  49m  164 R    1  0.6   0:00.99 stress
  3809 war       18   0  256m  54m  164 R    1  0.7   0:01.16 stress
  3814 war       18   0  256m  38m  164 R    1  0.5   0:00.97 stress
  3815 war       18   0  256m  69m  164 R    1  0.9   0:01.06 stress
   246 root      15   0     0    0    0 D    0  0.0   0:00.01 pdflush
  3687 war       15   0 18012  896  560 R    0  0.0   0:00.88 top
  3775 war       18   0  256m 153m  164 R    0  2.0   0:01.14 stress
  3776 war       18   0  256m  55m  164 R    0  0.7   0:01.34 stress
  3784 war       18   0  256m  13m  164 R    0  0.2   0:00.96 stress
  3789 war       18   0  256m  46m  164 R    0  0.6   0:01.54 stress
  3792 war       18   0  256m  12m  164 R    0  0.2   0:01.00 stress
  3793 war       18   0  256m  44m  164 R    0  0.6   0:00.96 stress
  3795 war       18   0  256m 196m  164 R    0  2.5   0:01.06 stress
  3802 war       18   0  256m  22m  160 R    0  0.3   0:02.70 stress
  3810 war       18   0  256m  40m  164 R    0  0.5   0:01.06 stress
  3818 war       18   0  256m 146m  160 R    0  1.9   0:00.34 stress
  3829 war       18   0  256m 130m  164 R    0  1.7   0:01.11 stress
   247 root      15   0     0    0    0 D    0  0.0   0:00.01 pdflush
   554 root      10  -5     0    0    0 D    0  0.0   0:00.01 md2_raid1
  3811 war       18   0  256m  61m  160 R    0  0.8   0:05.85 stress
  3821 war       18   0  256m 136m  160 R    0  1.7   0:00.37 stress
  3823 war       18   0  256m 204m  160 R    0  2.6   0:00.34 stress
  3826 war       18   0  256m  95m  164 R    0  1.2   0:01.03 stress





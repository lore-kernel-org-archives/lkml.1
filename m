Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbXGTCdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbXGTCdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 22:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbXGTCdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 22:33:01 -0400
Received: from mail.tmr.com ([64.65.253.246]:56065 "EHLO posidon.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXGTCdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 22:33:00 -0400
Message-ID: <46A01EC1.10008@tmr.com>
Date: Thu, 19 Jul 2007 22:32:33 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ian Kent <raven@themaw.net>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v19
References: <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com> <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu> <1184648474.3188.33.camel@raven.themaw.net> <20070717074537.GA13539@elte.hu> <alpine.LFD.0.999.0707180852540.27353@woody.linux-foundation.org> <469E8821.3070700@tmr.com> <20070719143214.GA6387@elte.hu>
In-Reply-To: <20070719143214.GA6387@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------050903090303060606000109"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050903090303060606000109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> * Bill Davidsen <davidsen@tmr.com> wrote:
> 
>>> Does the patch below help?
>> Spectacularly no! With this patch the "glitch1" script with multiple 
>> scrolling windows has all xterms and glxgears stop totally dead for 
>> ~200ms once per second. I didn't properly test anything else after 
>> that.
> 
> Bill, could you try the patch below - does it fix the automount problem, 
> without introducing new problems?
> 
Okay, as noted off-list, after I exported the xtime_seconds it now 
builds and works. However, there are a *lot* of "section mismatches" 
which are not reassuring.

Boots, runs, glitch1 test runs reasonably smoothly. automount has not 
used significant CPU yet, but I don't know what triggers it, the bad 
behavior did not happen immediately without the patch. However, it looks 
very hopeful.

Warnings attached to save you the trouble...

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

--------------050903090303060606000109
Content-Type: text/plain;
 name="make01pb.des"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="make01pb.des"

Script started on Thu 19 Jul 2007 05:29:08 PM EDT
Common profile 1.13 lastmod 2006-01-04 22:43:25-05
No common directory available
Session time 17:29:08 on 07/19/07
posidon:davidsen> time nice -10 make -j4 -s; sleep 2; exit
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CHK     include/linux/compile.h
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CHK     include/linux/version.h
  Building modules, stage 2.
WARNING: vmlinux(.text+0xc1001183): Section mismatch: reference to .init.text:start_kernel (between 'is386' and 'check_x87')
WARNING: vmlinux(.text+0xc1213fb4): Section mismatch: reference to .init.text: (between 'rest_init' and 'kthreadd_setup')
WARNING: vmlinux(.text+0xc1218786): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc1218792): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc121879e): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc12187aa): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
WARNING: vmlinux(.text+0xc1214071): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'alloc_node_mem_map' and 'zone_wait_table_init')
WARNING: vmlinux(.text+0xc1214117): Section mismatch: reference to .init.text:__alloc_bootmem_node (between 'zone_wait_table_init' and 'schedule')
WARNING: vmlinux(.text+0xc10fbaae): Section mismatch: reference to .init.text:__alloc_bootmem (between 'vgacon_startup' and 'vgacon_scrolldelta')
WARNING: vmlinux(.text+0xc1218eda): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
Root device is (253, 0)
Setup is 11240 bytes (padded to 11264 bytes).
System is 1915 kB
Kernel: arch/i386/boot/bzImage is ready  (#3)

real	4m11.024s
user	2m5.121s
sys	0m30.952s
exit

Script done on Thu 19 Jul 2007 05:33:35 PM EDT

--------------050903090303060606000109--

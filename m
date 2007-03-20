Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbXCTLO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbXCTLO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 07:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbXCTLO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 07:14:29 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36002 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752808AbXCTLO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 07:14:28 -0400
Date: Tue, 20 Mar 2007 12:14:30 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Tobias Diedrich <ranma@tdiedrich.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [1/6] 2.6.21-rc4: known regressions
Message-ID: <20070320111430.GB752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184908.GU752@stusta.de> <20070320102440.GB7517@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070320102440.GB7517@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 11:24:41AM +0100, Tobias Diedrich wrote:
> Adrian Bunk wrote:
> > This email lists some known regressions in Linus' tree compared to 2.6.20.
> 
> Since I didn't see any mention of this:
> 
> I'm seeing an Oops when removing the ohci1394 module:
> 
> [   16.047275] ieee1394: Node removed: ID:BUS[158717321-38:0860]  GUID[c033ced600000000]
> [   16.047287] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000094
> [   16.047451]  printing eip:
> [   16.047524] c02daf3d
> [   16.047527] *pde = 00000000
> [   16.047603] Oops: 0000 [#1]
> [   16.047676] PREEMPT 
> [   16.047788] Modules linked in: backlight ohci1394 parport_pc parport
> [   16.048069] CPU:    0
> [   16.048071] EIP:    0060:[<c02daf3d>]    Not tainted VLI
> [   16.048074] EFLAGS: 00010246   (2.6.21-rc4 #35)
> [   16.048298] EIP is at class_device_remove_attrs+0xa/0x30
> [   16.048377] eax: dfd04338   ebx: 00000000   ecx: df655988   edx: 00000000
> [   16.048456] esi: 00000000   edi: dfd04338   ebp: 00000000   esp: df506e38
> [   16.048535] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> [   16.048614] Process rmmod (pid: 1455, ti=df506000 task=df6cc0b0 task.ti=df506000)
> [   16.048693] Stack: dfd04338 dfd04340 00000000 c02db02f 00000000 dfd04338 dfd041e4 c0331871 
> [   16.049159]        00000000 c02db065 dfd041b0 c0331858 c055006d 0975d589 00000026 0000035c 
> [   16.049626]        00000000 c033ced6 00000000 df24c000 c0331879 c02d859f df24c0bc df24c0bc 
> [   16.050091] Call Trace:
> [   16.050233]  [<c02db02f>] class_device_del+0xcc/0xfa
> [   16.050352]  [<c0331871>] __nodemgr_remove_host_dev+0x0/0xb
>...
> [   16.057248] EIP: [<c02daf3d>] class_device_remove_attrs+0xa/0x30 SS:ESP 0068:df506e38
>...

You missed the following entry in my list [1]:

Subject    : Oops in __nodemgr_remove_host_dev
References : http://lkml.org/lkml/2007/3/14/4
             http://lkml.org/lkml/2007/3/18/87
Submitter  : Ismail Dönmez <ismail@pardus.org.tr>
             Stefan Richter <stefanr@s5r6.in-berlin.de>
             Thomas Meyer <thomas@m3y3r.de>
Caused-By  : Greg Kroah-Hartman <gregkh@suse.de>
             commit 43cb76d91ee85f579a69d42bc8efc08bac560278
             commit 40cf67c5fcc513406558c01b91129280208e57bf
Handled-By : Stefan Richter <stefanr@s5r6.in-berlin.de>
Status     : problem is being debugged


cu
Adrian

[1] not meant as an offence - there are so many items in the list
    that it's easy to miss one

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


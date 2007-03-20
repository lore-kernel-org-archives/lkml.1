Return-Path: <linux-kernel-owner+w=401wt.eu-S965176AbXCTKZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965176AbXCTKZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 06:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965310AbXCTKZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 06:25:15 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:4605 "EHLO yumi.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965176AbXCTKZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 06:25:13 -0400
Date: Tue, 20 Mar 2007 11:24:41 +0100
From: Tobias Diedrich <ranma@tdiedrich.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [1/6] 2.6.21-rc4: known regressions
Message-ID: <20070320102440.GB7517@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	Adrian Bunk <bunk@stusta.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184908.GU752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318184908.GU752@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This email lists some known regressions in Linus' tree compared to 2.6.20.

Since I didn't see any mention of this:

I'm seeing an Oops when removing the ohci1394 module:

[   16.047275] ieee1394: Node removed: ID:BUS[158717321-38:0860]  GUID[c033ced600000000]
[   16.047287] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000094
[   16.047451]  printing eip:
[   16.047524] c02daf3d
[   16.047527] *pde = 00000000
[   16.047603] Oops: 0000 [#1]
[   16.047676] PREEMPT 
[   16.047788] Modules linked in: backlight ohci1394 parport_pc parport
[   16.048069] CPU:    0
[   16.048071] EIP:    0060:[<c02daf3d>]    Not tainted VLI
[   16.048074] EFLAGS: 00010246   (2.6.21-rc4 #35)
[   16.048298] EIP is at class_device_remove_attrs+0xa/0x30
[   16.048377] eax: dfd04338   ebx: 00000000   ecx: df655988   edx: 00000000
[   16.048456] esi: 00000000   edi: dfd04338   ebp: 00000000   esp: df506e38
[   16.048535] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[   16.048614] Process rmmod (pid: 1455, ti=df506000 task=df6cc0b0 task.ti=df506000)
[   16.048693] Stack: dfd04338 dfd04340 00000000 c02db02f 00000000 dfd04338 dfd041e4 c0331871 
[   16.049159]        00000000 c02db065 dfd041b0 c0331858 c055006d 0975d589 00000026 0000035c 
[   16.049626]        00000000 c033ced6 00000000 df24c000 c0331879 c02d859f df24c0bc df24c0bc 
[   16.050091] Call Trace:
[   16.050233]  [<c02db02f>] class_device_del+0xcc/0xfa
[   16.050352]  [<c0331871>] __nodemgr_remove_host_dev+0x0/0xb
[   16.050475]  [<c02db065>] class_device_unregister+0x8/0x10
[   16.050595]  [<c0331858>] nodemgr_remove_ne+0x61/0x7a
[   16.050714]  [<c033ced6>] ether1394_header_cache+0x0/0x43
[   16.050835]  [<c0331879>] __nodemgr_remove_host_dev+0x8/0xb
[   16.050954]  [<c02d859f>] device_for_each_child+0x1a/0x3c
[   16.051073]  [<c0331b98>] nodemgr_remove_host+0x30/0x90
[   16.051192]  [<c032f12c>] __unregister_host+0x1a/0xad
[   16.051311]  [<c032ee17>] hl_get_hostinfo+0x5b/0x76
[   16.051430]  [<c032f34a>] highlevel_remove_host+0x21/0x42
[   16.051549]  [<c032ed9d>] hpsb_remove_host+0x37/0x56
[   16.051668]  [<e0869263>] ohci1394_pci_remove+0x44/0x1c7 [ohci1394]
[   16.051794]  [<c027e5b0>] pci_device_remove+0x16/0x35
[   16.053376]  [<c02da6d7>] __device_release_driver+0x6e/0x8b
[   16.053496]  [<c02dab77>] driver_detach+0xa1/0xde
[   16.053613]  [<c02da33f>] bus_remove_driver+0x57/0x75
[   16.053733]  [<c02dabd4>] driver_unregister+0x8/0x13
[   16.053850]  [<c027e732>] pci_unregister_driver+0xc/0x6e
[   16.053969]  [<c0134d56>] sys_delete_module+0x174/0x19a
[   16.054091]  [<c0113cea>] do_page_fault+0x277/0x525
[   16.054211]  [<c0148b0d>] do_munmap+0x193/0x1ac
[   16.054331]  [<c0103d0c>] syscall_call+0x7/0xb
[   16.054450]  =======================
[   16.054523] Code: ff c3 85 c0 74 08 83 c0 08 e9 9b f8 ea ff b8 ea ff ff ff c3 85 c0 74 08 83 c0 08 e9 b9 db ea ff c3 57 89 c7 56 53 31 db 8b 70 44 <83> be 94 00 00 00 00 75 09 eb 17 89 f8 e8 d7 ff ff ff 89 da 83 
[   16.057248] EIP: [<c02daf3d>] class_device_remove_attrs+0xa/0x30 SS:ESP 0068:df506e38

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de

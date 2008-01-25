Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbYAYXV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbYAYXV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762053AbYAYXUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:20:53 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:4056 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083AbYAYXUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:20:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cY7jpGw4MEe914vZhoVdsJBsjBihIv0Lpe3OcZtjA6CvTbZGO2YSK/rq4FKzo/vqt+GfZyzuj0vQLJ2QxXDB6bFPuj1VAlbJmnUXeLYzKe7lE9MB+vjmQ2oCtvoA0wVHZP4LzbY+uywY/q6kvz/b42wnpUAJBoftXGcJ8FnHTCw=
Message-ID: <86802c440801251520h29965fa4neaa4d17ebca955c3@mail.gmail.com>
Date: Fri, 25 Jan 2008 15:20:45 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: threshold_init_device/kobject_uevent_env oops
Cc: "Ingo Molnar" <mingo@elte.hu>, jacob.shin@amd.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080125230802.GA25074@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440801251305u21517078y12ff68ef3015aaae@mail.gmail.com>
	 <20080125221548.GA15172@suse.de> <20080125223556.GB24708@elte.hu>
	 <20080125230802.GA25074@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 3:08 PM, Greg KH <gregkh@suse.de> wrote:
> On Fri, Jan 25, 2008 at 11:35:56PM +0100, Ingo Molnar wrote:
..
> Also, can someone enable CONFIG_KOBJECT_DEBUG and send me the output of
> the startup of this code?  That should help explain what order things
> are happening it.

Calling initcall 0xffffffff80ba1dee: threshold_init_device+0x0/0x3f()
kobject: 'threshold_bank4' (ffff8108265450c0): kobject_add_internal:
parent: 'machinecheck0', set: '<NULL>'
kobject: 'misc0' (ffff810425497418): kobject_add_internal: parent:
'threshold_bank4', set: '<NULL>'
kobject: 'misc1' (ffff810425497498): kobject_add_internal: parent:
'threshold_bank4', set: '<NULL>'
kobject: 'misc2' (ffff810425497518): kobject_add_internal: parent:
'threshold_bank4', set: '<NULL>'
Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP:
 [<ffffffff8045d443>] kobject_uevent_env+0x31/0x45f
PGD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-smp-g99f1c97d-dirty #2
RIP: 0010:[<ffffffff8045d443>]  [<ffffffff8045d443>]
kobject_uevent_env+0x31/0x45f
RSP: 0000:ffff81042645bb50  EFLAGS: 00010286
RAX: ffffffff809a2906 RBX: 0000000000000000 RCX: ffffffff8084b050
RDX: 0000000000000018 RSI: 0000000000000000 RDI: 0000000000000018
RBP: 0000000000000018 R08: ffff8108265ffaf0 R09: 00000000265ffaf0
R10: ffffc20002eb9ad0 R11: ffff8108265ffaf0 R12: 0000000000000000
R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000004
FS:  0000000000000000(0000) GS:ffffffff80b4f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81042645a000, task ffff81082643c000)
Stack:  ffff8108265ffaf0 00000000802c7ffe ffffffff809a2906 ffffffff80a96f10
 ffff8108265ffc30 0000000000000000 ffff8108265ffaf0 ffff8108265450c0
 0000000000000004 ffffffff802c7b93 00000000265ffaf0 00000000c000040f
Call Trace:
 [<ffffffff802c7b93>] sysfs_add_file+0x5b/0x81
 [<ffffffff80215fcb>] allocate_threshold_blocks+0x184/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80215fb9>] allocate_threshold_blocks+0x172/0x1b0
 [<ffffffff80216236>] threshold_create_device+0x23f/0x32e
 [<ffffffff8023fede>] __mod_timer+0xc3/0xd3
 [<ffffffff80ba1e04>] threshold_init_device+0x16/0x3f
 [<ffffffff80b9963a>] kernel_init+0x175/0x2e1
 [<ffffffff8020cd48>] child_rip+0xa/0x12
 [<ffffffff80b994c5>] kernel_init+0x0/0x2e1
 [<ffffffff8020cd3e>] child_rip+0x0/0x12


Code: 48 8b 37 31 c0 48 c7 c7 34 68 9d 80 e8 80 aa dd ff 48 89 e8
RIP  [<ffffffff8045d443>] kobject_uevent_env+0x31/0x45f
 RSP <ffff81042645bb50>
CR2: 0000000000000018
---[ end trace 778e504de7e3b1e3 ]---

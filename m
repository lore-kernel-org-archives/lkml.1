Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbYCPGZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbYCPGZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 02:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYCPGZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 02:25:23 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:33017 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYCPGZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 02:25:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=dgu7qwbQCX9YUqTtu07Y2MsDUsJEgSmKzscTtcSKss3KcdtSgLR7hHS2utvD6ynA7Z9dSDr1v1NnxIOrrjVjMrQ2UXVwxblE7A1vUfVMCbWxeKReDwb1BDyIjj6tJf3Xj0JqElNZKGsVII0riNHanUN5dpXTN5DXgKfjv/2hcjA=
Message-ID: <76366b180803152325x63424d09vb775b5ed44b961e1@mail.gmail.com>
Date: Sun, 16 Mar 2008 02:25:21 -0400
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24.3 kernel panic in md raid1d queue_delayed_work_on
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 433f2b6ebed75439
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had an embedded machine hang last night with a kernel panic in
queue_delayed_work_on. I couldn't scroll back the terminal to get more
of the trace, but I jotted down what I could see on the screen. This
is a Geode LX system running a SATA RAID1 array as md0 on a SiI 3114
controller using libata. Any ideas? If the .config or boot log from
this machine would be useful, let me know and I'll get them.

Thanks,
-Andrew

----- top of scrollback
handle_IRQ_event+0x1a/0x3f
handle_level_irq+0x4f/0x84
do_IRQ+0x53/0x6b
common_interrupt+0x23/0x28
__make_request+0x480/0x48a
generic_make_request+0x1fd/0x22a
common_interrupt+0x23/0x28
__generic_unplug_device+0x14/0x1f
generic_unplug_device+0x6/0x8
blk_remove_plug+0x4e/0x5a
raid1d+0xc3/0xc35
irq_exit+0x40/0x58
do_IRQ+0x58/0x6b
update_curr+0x52/0xc4
schedule+0x1f3/0x20d
schedule_timeout+0x13/0x97
sys_capget+0x54/0xcb
md_thread+0xb5/0xcb
autoremove_wake_function+0x0/0x35
md_thread+0x0/0xcb
kthread+0x36/0x5c
kthread+0x0/0x5c
kernel_thread_helper+0x7/0x10

Code: 8d 50 10 e9 48 ff ff ff 31 d2 e9 41 ff ff ff 57 89 c7 56 89 d6
53 8d 59 3(clipped)
 0f ba 29 00 19 c0 31 d2 85 c0 75 61 83 79 10 00 74 04 <0f> 0b eb fe
8d 41 04 3(clipped)
 41 04 74 04 0f 0b eb fe 8b 01 8b 16 a8
EIP: [<c022609a>] queue_delayed_work_on+0x1c/0x7d SS:ESP 0068:cf359d80
Kernel panic - not syncing: Fatal exception in interrupt

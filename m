Return-Path: <linux-kernel-owner+w=401wt.eu-S1946510AbXBIPOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946510AbXBIPOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946511AbXBIPOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:14:52 -0500
Received: from web36703.mail.mud.yahoo.com ([209.191.85.37]:36511 "HELO
	web36703.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1946510AbXBIPOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:14:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=1mfntgsjshtX6zxoQ+sGUBHkB3/w5ugkAc5L76FCfQDr/m4xft/J16oXfaVMafrzTVPavUvDvjbR1U/nsbs4fCazzwlBkRBXefK5fUKvo9u20i96SBd4XEEGJdrEy404QTQ0G34emjuVbNpDTXJ7JKhgPYoFfSO8X8sHmRYgsco=;
X-YMail-OSG: em7QC8YVM1mzS5JtceoKT07vmcXM3d79OJ14po0WVFMOyqrEt2ntZa0BMLTwv2qkvHFr4nJXZypsHb0Hf7aP0cPV.HAKVHhBBVmlj5dDM.Yd2DbQw_yOV5cQRamQjfLQQ_b7DGttqLakKCg-
Date: Fri, 9 Feb 2007 07:14:50 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Recent and not-so problems with tifm_sd driver
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45CABC2B.7070704@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <555089.84713.qm@web36703.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings.

It seems that the recent shower of error reports was caused by my not so thorough testing of the
R6 handling problems (I've sent you a patch for this).

However, there is this other problem with mmc_host_remove while transfer is in progress.
First, I disabled my "sleep on remove" hack. Then I've set up a transfer (dd if=/dev/mmcblk0
of=/dev/null) and pulled the card out. The result was a hard crash (irq handler style) soon
followed by additional one, so the numbers in this hand-grabbed dump may be inexact:
--------
elv_next_request+0x15d/0x1e0
:mmc_core:mmc_queue_thread+0x72/0x110
:mmc_core:mmc_queue_thread+0x0/0x110
keventd_create_kthread+0x0/0x90
kthread+0xd9/0x120
child_rip+0xa/0x12
keventd_create_kthread+0x0/0x90
kthread+0x0/0x120
child_rip+0x0/0x12

RIP :mmc_core:mmc_prep_request+0x4d/0x70
----------
I'm continuing to look for possible problems in my code.



 
____________________________________________________________________________________
It's here! Your new message!  
Get new email alerts with the free Yahoo! Toolbar.
http://tools.search.yahoo.com/toolbar/features/mail/

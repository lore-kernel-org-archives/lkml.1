Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347Ab0AQCzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab0AQCzq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 21:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311Ab0AQCzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 21:55:46 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50152 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0AQCzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 21:55:45 -0500
Date: Sun, 17 Jan 2010 02:55:35 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: dvomlehn@cisco.com
Cc: gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes"
	causes gobi_loader to hang
Message-ID: <20100117025535.GB7045@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gobi_loader writes firmware to gobi USB devices (qcserial) via the USB 
serial layer by writing it a megabyte at a time (matching the Windows 
driver behaviour). Commit 8e8dce065088833fc418bfa5fbf035cb0726c04c 
breaks it - strace shows the write simply hanging. ssyrq-t says the 
backtrace is:

Jan 17 15:37:37 localhost kernel: Call Trace:
Jan 17 15:37:37 localhost kernel: [<ffffffff8128986c>] n_tty_write+0x2da/0x351
Jan 17 15:37:37 localhost kernel: [<ffffffff810464b4>] ? default_wake_function+0x0/0x14
Jan 17 15:37:37 localhost kernel: [<ffffffff81286969>] tty_write+0x19d/0x245
Jan 17 15:37:37 localhost kernel: [<ffffffff81289592>] ? n_tty_write+0x0/0x351
Jan 17 15:37:37 localhost kernel: [<ffffffff81103e44>] vfs_write+0xae/0x10b
Jan 17 15:37:37 localhost kernel: [<ffffffff81103f61>] sys_write+0x4a/0x6e
Jan 17 15:37:37 localhost kernel: [<ffffffff81009e45>] tracesys+0xd9/0xde

The commit before this works fine.
-- 
Matthew Garrett | mjg59@srcf.ucam.org

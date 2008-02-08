Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYBHPZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYBHPZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 10:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbYBHPZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 10:25:16 -0500
Received: from verein.lst.de ([213.95.11.210]:49375 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbYBHPZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 10:25:15 -0500
Date: Fri, 8 Feb 2008 16:25:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: current mainline ide doesn't like qemu/kvm (or vice versa)
Message-ID: <20080208152508.GA16290@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to put some stress on qemu by running the xfs testsuite
I get the following:

debian:~/xfs-cmds/xfstests# sh check 
[  438.166822] SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
[  438.185557] SGI XFS Quota Management subsystem
[  438.193150] hdb: task_no_data_intr: status=0x41 { DriveReady Error }
[  438.194018] hdb: task_no_data_intr: error=0x04 { DriveStatusError }
[  438.194195] ide: failed opcode was: 0x9d

and after that the kernel seems to hang.  Qemu is emulating a piix3
device, and using the piix driver.  This is on a pretty old kvm (version
28) because newer ones don't even compile.

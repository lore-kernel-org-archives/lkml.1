Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbYE2Ljp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbYE2Ljp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYE2Ljh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:39:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35279 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYE2Ljg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:39:36 -0400
Date: Thu, 29 May 2008 12:38:57 +0100 (BST)
From: Alexey Korolev <akorolev@infradead.org>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
cc: linux-kernel@vger.kernel.org
Subject: [BUG] JFFS2 power loss recovery issues in 2.6.25, 2.6.26-rc
Message-ID: <alpine.LFD.1.10.0805291205480.22130@pentafluge.infradead.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <akorolev@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

One of recent patches broke JFFS2 power loss recoverability.
We faced the issue in Linux 2.6.25 and 2.6.26-rc but not in 2.6.24,
2.6.23.

If to reboot platform during file write. And try to read it again rest
of file will contain trash. 
Issue is well reproducible on NAND, especially if to delete large file
before write and reboot.

We made some investigations for this issue and found commit number which
breaks JFFS2 power loss recoverability.
It is:  [JFFS2] Improve getdents vs. f_pos handling on NOR flash.
        http://git.infradead.org/mtd-2.6.git?a=commitdiff;h=15953580e79b58caefb107e77f218e009b9992e6

Currently we don't know why it breaks JFFS2 and how it could be fixed
except roll back. 
So I would much appreciate any ideas on how it could be fixed. 


Thanks


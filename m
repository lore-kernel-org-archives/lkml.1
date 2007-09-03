Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbXICGnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbXICGnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 02:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbXICGnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 02:43:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37307 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbXICGnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 02:43:14 -0400
Date: Mon, 3 Sep 2007 08:43:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk,
       bharata@linux.vnet.ibm.com, j.blunck@tu-harburg.de,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 05/32] Unionfs: do not use fsstack_copy_attr_all
In-Reply-To: <11887860561137-git-send-email-jsipek@cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0709030840110.4454@fbirervta.pbzchgretzou.qr>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
 <11887860561137-git-send-email-jsipek@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 2 2007 22:20, Josef 'Jeff' Sipek wrote:
>+/* copy a/m/ctime from the lower branch with the newest times */
>+static inline void unionfs_copy_attr_times(struct inode *upper)
>+{
>
>+		/* XXX: should we notify_change on our upper inode? */

I do not think so. Inotifying should only happen when the user really 
did something (e.g. touch, cp, whatever). When merely the newest time is 
picked from a stack of files and applied to the user-visible dentry, 
nothing should happen.


	Jan
-- 

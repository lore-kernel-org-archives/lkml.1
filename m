Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZDZDtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZDZDtu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 23:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZDZDte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 23:49:34 -0400
Received: from THUNK.ORG ([69.25.196.29]:60014 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbZDZDtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 23:49:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH RFC 0/5] Eliminate most lock_super() calls from ext4
Date: Sat, 25 Apr 2009 23:49:20 -0400
Message-Id: <1240717765-16572-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.3
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, Apr 24, 2009 at 08:40:47PM +0200, Christoph Hellwig wrote:
> ext3/4 internal bits?  Doesn't seem to be used for any journal related
> activity but mostly as protection against resizing (the whole lock_super
> usage in ext3/4 looks odd to me, interestingly there's none at all in
> ext2.  Maybe someone of the extN crowd should audit and get rid of it in
> favour of a better fs-specific lock)

Here are some patches which eliminate most of the lock_super() and
unlock_super() calls from ext4.  The last remaining calls are designed
to proect against another CPU calling write_super(), which is the
original intended use.   

If these patches work out, we can backport these patches to ext3.

Comments and review appreciated; thanks!!

						- Ted


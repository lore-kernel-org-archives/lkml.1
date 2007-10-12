Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbXJLRHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbXJLRHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932602AbXJLRGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:06:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932565AbXJLRGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:06:48 -0400
Date: Fri, 12 Oct 2007 18:06:42 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [2.6.24 PATCH 04/25] dm crypt: missing kfree in ctr error path
Message-ID: <20071012170642.GO24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

Insert missing kfree() in crypt_iv_essiv_ctr() error path.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-crypt.c |    1 +
 1 files changed, 1 insertion(+)

Index: linux-2.6.23/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-crypt.c	2007-10-12 13:15:30.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-crypt.c	2007-10-12 13:15:31.000000000 +0100
@@ -175,6 +175,7 @@ static int crypt_iv_essiv_ctr(struct cry
 
 	if (err) {
 		ti->error = "Error calculating hash in ESSIV";
+		kfree(salt);
 		return err;
 	}
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbXITFGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbXITFGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbXITFGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:06:16 -0400
Received: from smtp102.plus.mail.re1.yahoo.com ([69.147.102.65]:46661 "HELO
	smtp102.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750899AbXITFGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:06:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=JMujZO6raE4UbY1XFYhG8Ux8SOcMDAoLpJb46HiiQwXgMBuTyYlSwBpZn+5wEpE6/VtTDrD0u4J0zysWsdAdCFWGFt3PcI1lsk+d7zjoJHVmIUlLEoOBKq5ZdVbh6BSa20QVpGSuQesA4TZwg/zoAkt1GLe8rqk32Eo2xswvQ/4=  ;
X-YMail-OSG: 7oz8oMQVM1kEzuqkrfwqJZJFUhM4HxMpS9kcdTL1xiIVxA_STOtuyW1AfcUfFD6eZZAg16G0cA--
Date: Thu, 20 Sep 2007 07:05:37 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] fs/isofs/namei.c: Remove uninitialized local vars warning,
	was: Re: Arr! Linux 2.6.23-rc7
Message-ID: <20070920050537.GA9244@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <alpine.LFD.0.999.0709191605530.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.999.0709191605530.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

   since there's no iso9660 maintainer i send this one to you :).
---
From: Borislav Petkov <bbpetkov@yahoo.de>

shut up those:
fs/isofs/namei.c: In function 'isofs_lookup':
fs/isofs/namei.c:161: warning: 'offset' may be used uninitialized in this function
fs/isofs/namei.c:161: warning: 'block' may be used uninitialized in this function

By the way, they get overwritten at the end of isofs_find_entry().

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

 fs/isofs/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--
--- 23-rc7/fs/isofs/namei.c.orig	2007-09-20 06:34:19.000000000 +0200
+++ 23-rc7/fs/isofs/namei.c	2007-09-20 06:35:23.000000000 +0200
@@ -158,7 +158,8 @@ isofs_find_entry(struct inode *dir, stru
 struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	int found;
-	unsigned long block, offset;
+	unsigned long uninitialized_var(block);
+	unsigned long uninitialized_var(offset);
 	struct inode *inode;
 	struct page *page;
 
-- 
Regards/Gruﬂ,
    Boris.

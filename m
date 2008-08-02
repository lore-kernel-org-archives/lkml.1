Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYHBDbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYHBDbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 23:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYHBDaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 23:30:52 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:45353 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbYHBDaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 23:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=RipvMk/SB0UUQBs3XKcgtXhIDzETEhg33I6iZJ0fJHznRIVm0VNeQy12XPzj+pIZsr
         pAPv7lk/wyOtpEw2k37YXSa5eP89e9jfVgnn4mVpNAIYZBp5MefvWO8zovisIukFivYy
         OmwybkMbEvMyOvIkK4nKWQz/gDsm6MwcDGiXY=
Date: Sat, 2 Aug 2008 07:30:48 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: inode number fixlet
Message-ID: <20080802033048.GA3758@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ouch, if number taken from IDA is too big, the intent was to signal an
error, not check for overflow and still do overflowing addition.

One still needs 2^28 proc entries to notice this.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -330,6 +330,7 @@ retry:
 		spin_lock(&proc_inum_lock);
 		ida_remove(&proc_inum_ida, i);
 		spin_unlock(&proc_inum_lock);
+		return 0;
 	}
 	return PROC_DYNAMIC_FIRST + i;
 }


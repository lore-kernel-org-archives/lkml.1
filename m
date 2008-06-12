Return-Path: <linux-kernel-owner+w=401wt.eu-S1759094AbYFLBga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094AbYFLBga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 21:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYFLBgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 21:36:23 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:25009 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbYFLBgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 21:36:22 -0400
Date: Thu, 12 Jun 2008 02:36:11 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Bohac <jbohac@suse.cz>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console keyboard mapping broken by 04c71976
Message-ID: <20080612013611.GP4718@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiri Bohac <jbohac@suse.cz>, lkml <linux-kernel@vger.kernel.org>
References: <20080611134837.GA11462@midget.suse.cz> <20080612011832.GM4718@implementation> <20080611182706.f8e2cc8c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080611182706.f8e2cc8c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton, le Wed 11 Jun 2008 18:27:06 -0700, a écrit :
> Is this ready to be applied?  If so, please send a changelog.

Ah, right, there was no changelog.



From: Jiri Bohac <jbohac@suse.cz>

Several console keyboard maps are broken since 04c71976, because that
changeset made k_self consider the value as a latin1 character when in
Unicode mode, which is wrong; k_self should still take the console map
into account.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 7f7e798..16492b7 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -678,10 +678,5 @@
 static void k_self(struct vc_data *vc, unsigned char value, char up_flag)
 {
-	unsigned int uni;
-	if (kbd->kbdmode == VC_UNICODE)
-		uni = value;
-	else
-		uni = conv_8bit_to_uni(value);
-	k_unicode(vc, uni, up_flag);
+	k_unicode(vc, conv_8bit_to_uni(value), up_flag);
 }

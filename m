Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYFLBZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYFLBZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 21:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbYFLBZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 21:25:18 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:26860 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755522AbYFLBZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 21:25:16 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2008 21:25:16 EDT
Date: Thu, 12 Jun 2008 02:18:32 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Jiri Bohac <jbohac@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console keyboard mapping broken by 04c71976
Message-ID: <20080612011832.GM4718@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Jiri Bohac <jbohac@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20080611134837.GA11462@midget.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611134837.GA11462@midget.suse.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, a closer look agrees with the patch, but no need to keep the uni
variable then, here is an updated patch.  Thanks!

From: Jiri Bohac <jbohac@suse.cz>
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


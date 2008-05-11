Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbYEKTvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbYEKTvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYEKTv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:51:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:30372 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYEKTv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=jdZlnywoUHK1GI3iUFL3xknVwMEyc6r2hbszK/9hVPDsbhktko4PTLem/YvoAXHvneR2P917HEvJCdP78SbiXMJTo1lLqoSLSAG2FeeAmQPiWCjXFRcu25J4duRZ8deK9lJ7a2rVLhUxS3CDh66GtCGRQheyBm3vL9u3QdBVc1M=
Date: Sun, 11 May 2008 21:51:07 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] v4l: fix handling of tea5761_autodetection return value
Message-ID: <20080511195103.GB19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tea5761_autodetection returns -EINVAL on error

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
compile tested only
---
 drivers/media/common/tuners/tea5761.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/tea5761.c b/drivers/media/common/tuners/tea5761.c
--- a/drivers/media/common/tuners/tea5761.c
+++ b/drivers/media/common/tuners/tea5761.c
@@ -295,7 +295,7 @@ struct dvb_frontend *tea5761_attach(struct dvb_frontend *fe,
 {
 	struct tea5761_priv *priv = NULL;
 
-	if (tea5761_autodetection(i2c_adap, i2c_addr) == EINVAL)
+	if (tea5761_autodetection(i2c_adap, i2c_addr) != 0)
 		return NULL;
 
 	priv = kzalloc(sizeof(struct tea5761_priv), GFP_KERNEL);
-- 

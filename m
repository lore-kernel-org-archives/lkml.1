Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbZJDTpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbZJDTpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 15:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbZJDTpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 15:45:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701AbZJDTpA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 15:45:00 -0400
Date: Sun, 4 Oct 2009 16:43:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, bluesmoke-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] i7core_edac: Better parse "any" addrmask
Message-ID: <20091004164342.32965b3c@pedra.chehab.org>
In-Reply-To: <20090924192821.7fcffc80@pedra.chehab.org>
References: <20090924192821.7fcffc80@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ddc7940d3a68483e750e286bfe78d52bdf9231d1 Mon Sep 17 00:00:00 2001
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Sun, 4 Oct 2009 11:54:56 -0300
Subject: [PATCH] i7core_edac: Better parse "any" addrmask

Instead of accepting just "any", accept also "any\n"

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7core_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 94aeca0..477b62a 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -800,7 +800,7 @@ static ssize_t i7core_inject_store_##param(			\
 	if (pvt->inject.enable)					\
 		disable_inject(mci);				\
 								\
-	if (!strcasecmp(data, "any"))				\
+	if (!strcasecmp(data, "any") || !strcasecmp(data, "any\n"))\
 		value = -1;					\
 	else {							\
 		rc = strict_strtoul(data, 10, &value);		

-- 

Cheers,
Mauro

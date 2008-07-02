Return-Path: <linux-kernel-owner+w=401wt.eu-S1763271AbYGBHXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763271AbYGBHXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761036AbYGBHXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:23:01 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:44877 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760861AbYGBHWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:22:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Pyt+zrlUdlY96aqblH/j/XVpSJ8X8emus66DtrY4qn8aEs6NEbHWpqZlU7DhDytj6z7GIhGX5lsb5NdcTQjORrzB7jEuT9Fyzpy0qor94eUOsgxpeAsMMnp9GZk1qTEJXB6e6BVeyoAVz8t2w50WYP1thXcoa+WV1iV7QNxRQTw=  ;
X-YMail-OSG: Mg3qFRUVM1njjWKOEj4ldES90Et48xrDf_qci386BPh60Na7PzOdezsXtRyM5rcji9TVPfXg_4lQFhem8NNJhPPV1f0t9RjfRhZGsBo4ljImVnOq1uEqKJl4bgCHv1bHOSM-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.26-rc8] parport: fix platform driver hotplug/coldplug
Date: Wed, 2 Jul 2008 00:20:21 -0700
User-Agent: KMail/1.9.9
Cc: kay.sievers@vrfy.org, lkml <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807020020.22002.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
modalias is prefixed with "platform:". Add MODULE_ALIAS() to the
hotpluggable parport platform drivers, to re-enable auto loading.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/parport/parport_ax88796.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/parport/parport_ax88796.c	2008-07-01 23:58:26.000000000 -0700
+++ b/drivers/parport/parport_ax88796.c	2008-07-01 23:59:18.000000000 -0700
@@ -406,6 +406,8 @@ static int parport_ax88796_resume(struct
 #define parport_ax88796_resume  NULL
 #endif
 
+MODULE_ALIAS("platform:ax88796-pp");
+
 static struct platform_driver axdrv = {
 	.driver		= {
 		.name	= "ax88796-pp",

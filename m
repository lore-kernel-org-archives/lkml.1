Return-Path: <linux-kernel-owner+w=401wt.eu-S1751764AbZJPWS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbZJPWS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 18:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZJPWS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 18:18:59 -0400
Received: from exprod6og105.obsmtp.com ([64.18.1.189]:57219 "HELO
	exprod6og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751145AbZJPWS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 18:18:58 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] clockevents.c: fix symbol was not declared noise
Date: Fri, 16 Oct 2009 18:19:01 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901E24550@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] clockevents.c: fix symbol was not declared noise
Thread-Index: AcpOrqm8FoAi08H5S9mlVmJFAy6sKg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Oct 2009 22:19:02.0554 (UTC) FILETIME=[AA8417A0:01CA4EAE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include "tick-internal.h" in order to pick up the extern function
prototype for clockevents_shutdown().  This quiets the following
spares build noise:

  warning: symbol 'clockevents_shutdown' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 620b58a..c30ba1f 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -20,6 +20,8 @@
 #include <linux/sysdev.h>
 #include <linux/tick.h>
 
+#include "tick-internal.h"
+
 /* The registered clock event devices */
 static LIST_HEAD(clockevent_devices);
 static LIST_HEAD(clockevents_released); 

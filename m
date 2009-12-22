Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbZLVQL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbZLVQL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 11:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZLVQL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 11:11:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33634 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbZLVQL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 11:11:56 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Oskar Schirmer <os@emlix.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] add missing include in lib/rational.c
Date: Tue, 22 Dec 2009 17:11:50 +0100
Message-Id: <1261498310-18985-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091008153037.GA13717@emlix.com>
References: <20091008153037.GA13717@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.ha...@pengutronix.de>

This fixes:

lib/rational.c:62: warning: data definition has no type or storage class
lib/rational.c:62: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
lib/rational.c:62: warning: parameter names (without types) in function declaration

Signed-off-by: Sascha Hauer <s.ha...@pengutronix.de>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Hi,

Oskar Schirmer wrote:
> > lib/rational.c:62: warning: data definition has no type or storage
> > class
> > lib/rational.c:62: warning: type defaults to 'int' in declaration of
> > 'EXPORT_SYMBOL'
> > lib/rational.c:62: warning: parameter names (without types) in
> > function declaration
>
> Oh yes, we didnt use it with modules up to now.
Note this has nothing to do if the symbol is used in modules or not.
It's just that EXPORT_SYMBOL (which publishes the symbol to the module
linker).  I havn't checked, but I assume the compiler interprets

	EXPORT_SYMBOL(rational_best_approximation);

just as declaration of a function EXPORT_SYMBOL and doesn't generate the
needed magic to actually export rational_best_approximation.

Best regards
Uwe
---
 lib/rational.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/rational.c b/lib/rational.c
index b3c099b..3ed247b 100644
--- a/lib/rational.c
+++ b/lib/rational.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/rational.h>
+#include <linux/module.h>
 
 /*
  * calculate best rational approximation for a given fraction
-- 
1.6.5.2


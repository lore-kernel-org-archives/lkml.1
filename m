Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576Ab0A3Ura@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0A3Ura (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488Ab0A3Ur1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:47:27 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43930 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab0A3Ur0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:47:26 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/7] modpost: members of *driver structs should not point to __init functions
Date: Sat, 30 Jan 2010 21:46:46 +0100
Message-Id: <1264884412-6173-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100130204425.GA16345@pengutronix.de>
References: <20100130204425.GA16345@pengutronix.de>
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

Either the functions referred to in a driver struct should live in
.devinit or the driver should be registered using platform_driver_probe
(or equivalent for different driver types) with ->probe being NULL.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 scripts/mod/modpost.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 2092361..713b62e 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -961,7 +961,7 @@ static int section_mismatch(const char *fromsec, const char *tosec)
  * Pattern 2:
  *   Many drivers utilise a *driver container with references to
  *   add, remove, probe functions etc.
- *   These functions may often be marked __init and we do not want to
+ *   These functions may often be marked __devinit and we do not want to
  *   warn here.
  *   the pattern is identified by:
  *   tosec   = init or exit section
-- 
1.6.6


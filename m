Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZF1NOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZF1NOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZF1NO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:14:29 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:35303 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZF1NO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:14:28 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] Char: cyclades, fix isa+module build
Date: Sun, 28 Jun 2009 15:13:42 +0200
Message-Id: <1246194822-17628-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_ISA and MODULES is turned on, a build will fail with
the following error:
drivers/char/cyclades.c:3332: error: assignment of read-only location

Deconstify that particular isa structure.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 5cec450..dbfa8b5 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -143,7 +143,7 @@ static struct tty_driver *cy_serial_driver;
    causing problems, remove the offending address from this table.
 */
 
-static const unsigned int cy_isa_addresses[] = {
+static unsigned int cy_isa_addresses[] = {
 	0xD0000,
 	0xD2000,
 	0xD4000,
-- 
1.6.3.2


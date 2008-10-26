Return-Path: <linux-kernel-owner+w=401wt.eu-S1752305AbYJZIyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbYJZIyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 04:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYJZIyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 04:54:04 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:10152 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYJZIyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 04:54:01 -0400
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <49043024.2010008@tremplin-utc.net>
Date: Sun, 26 Oct 2008 09:53:56 +0100
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080929 Mandriva/2.0.0.17-2mdv2009.0 (2009.0) Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Yan Burman <burman.yan@gmail.com>, Pau Oliva Fora <pau@eslack.org>
Subject: [PATCH] LIS3LV02D: Conform to the new ACPI API
References: <20081022154459.GA26291@elf.ucw.cz>
In-Reply-To: <20081022154459.GA26291@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ACPI API has been updated to allow 64bit return values in
acpi_evaluate_integer(). Update also the lis3lv02d driver so that it
works with 2.6.28-rc1.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/lis3lv02d.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 06d544e..752b5c4 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -112,7 +112,7 @@ static acpi_status lis3lv02d_acpi_read(acpi_handle
handle, int reg, u8 *ret)
 {
 	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
 	struct acpi_object_list args = { 1, &arg0 };
-	unsigned long lret;
+	unsigned long long lret;
 	acpi_status status;

 	arg0.integer.value = reg;
@@ -132,7 +132,7 @@ static acpi_status lis3lv02d_acpi_read(acpi_handle
handle, int reg, u8 *ret)
  */
 static acpi_status lis3lv02d_acpi_write(acpi_handle handle, int reg, u8
val)
 {
-	unsigned long ret; /* Not used when writting */
+	unsigned long long ret; /* Not used when writting */
 	union acpi_object in_obj[2];
 	struct acpi_object_list args = { 2, in_obj };

-- 
1.6.0.2


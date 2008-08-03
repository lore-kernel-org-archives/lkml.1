Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbYHCHYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbYHCHYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 03:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYHCHYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 03:24:31 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:10803 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYHCHYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 03:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=UXqAn/349veU/hzrWK12C/QBR/A9oFf4sSZucUceby0Dta8jU0QwFY2a8Rk+bRfI+3
         1c0bh2NQkySFlsuWxharFTVmfJQIczAm5isty3eYuuZqXNtze9uzLtq413tOGqod8X+T
         6Nj1X3MvBUOpzotxgYw7C9EuG9s4pTLaPh0kA=
Message-ID: <ea11fea30808030024v18912201x46d12fe389e508f8@mail.gmail.com>
Date: Sun, 3 Aug 2008 12:54:28 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: kernel-janitors@vger.kernel.org, astarikovskiy@suse.de,
       vladimir.p.lebedev@intel.com, LKML <linux-kernel@vger.kernel.org>,
       trivial@vger.kernel.org
Subject: [PATCH] Remove warning 'unused variable battery' in drivers/acpi/sbs.c
Cc: mkatiyar@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below patch removes the following warning:
drivers/acpi/sbs.c: In function 'acpi_battery_remove':
drivers/acpi/sbs.c:819: warning: unused variable 'battery'



Signed-off-by:- "Manish Katiyar" <mkatiyar@gmail.com>

---
 drivers/acpi/sbs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 10a3651..8493603 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -816,7 +816,9 @@ static int acpi_battery_add(struct acpi_sbs *sbs, int id)

 static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
 {
+#ifdef CONFIG_ACPI_SYSFS_POWER || CONFIG_ACPI_PROCFS_POWER
 	struct acpi_battery *battery = &sbs->battery[id];
+#endif
 #ifdef CONFIG_ACPI_SYSFS_POWER
 	if (battery->bat.dev) {
 		if (battery->have_sysfs_alarm)
-- 
1.5.4.3



Thanks -
Manish

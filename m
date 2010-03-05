Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab0CET43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:56:29 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:38748 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab0CET40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:56:26 -0500
Message-ID: <4B916169.5040303@oracle.com>
Date: Fri, 05 Mar 2010 11:54:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Alexey Starikovskiy <astarikovskiy@suse.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: [PATCH -mmotm] acpi/sbs: fix build for ACPI_SYSFS_POWER=n
References: <201003050232.o252WD4K011798@imap1.linux-foundation.org>
In-Reply-To: <201003050232.o252WD4K011798@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B9161B0.0182:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_ACPI_SYSFS_POWER is not enabled:

drivers/acpi/sbs.c:640: error: implicit declaration of function 'acpi_battery_get_alarm'
drivers/acpi/sbs.c:679: error: implicit declaration of function 'acpi_battery_set_alarm'


so move those functions outside of the ifdef/endif block for that
config option.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/acpi/sbs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm-2010-0304-1805.orig/drivers/acpi/sbs.c
+++ mmotm-2010-0304-1805/drivers/acpi/sbs.c
@@ -412,8 +412,6 @@ static int acpi_ac_get_present(struct ac
 	return result;
 }
 
-#ifdef CONFIG_ACPI_SYSFS_POWER
-
 static int acpi_battery_get_alarm(struct acpi_battery *battery)
 {
 	return acpi_smbus_read(battery->sbs->hc, SMBUS_READ_WORD,
@@ -450,6 +448,8 @@ static int acpi_battery_set_alarm(struct
 	return ret;
 }
 
+#ifdef CONFIG_ACPI_SYSFS_POWER
+
 static ssize_t acpi_battery_alarm_show(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)

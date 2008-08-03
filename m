Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYHCNMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYHCNMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 09:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbYHCNMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 09:12:30 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:44179 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYHCNM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 09:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ZMaq81Wsw7AeSx6J7mdmQ6EXUB+gFmCOoyGBvIMtpwrLG0ugd1y6GswonoXd6Kn6K9
         wrnHa4vMoj1Mu+cVS5QWYycaP/LGAIBOr2dmIeVkxA3kkx484+XzNv2R5qk73uOSybxH
         3v7b4WYFWZcqzGQR9byBN2Q6UOSXuYK13DbX0=
Message-ID: <ea11fea30808030612m7ab72e85xf34e290d674d955d@mail.gmail.com>
Date: Sun, 3 Aug 2008 18:42:27 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [PATCH] resend: Remove warning 'unused variable battery' in drivers/acpi/sbs.c
Cc: kernel-janitors@vger.kernel.org, astarikovskiy@suse.de,
       LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend of the patch to remove the following warning:
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
+#if defined (CONFIG_ACPI_SYSFS_POWER) || (CONFIG_ACPI_PROCFS_POWER)
       struct acpi_battery *battery = &sbs->battery[id];
+#endif
 #ifdef CONFIG_ACPI_SYSFS_POWER
       if (battery->bat.dev) {
               if (battery->have_sysfs_alarm)
--
1.5.4.3


Thanks -
Manish

On Sun, Aug 3, 2008 at 6:00 PM, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:
> On Sun, 3 Aug 2008, Manish Katiyar wrote:
>
>> Below patch removes the following warning:
>> drivers/acpi/sbs.c: In function 'acpi_battery_remove':
>> drivers/acpi/sbs.c:819: warning: unused variable 'battery'
>>
>>
>>
>> Signed-off-by:- "Manish Katiyar" <mkatiyar@gmail.com>
>>
>> ---
>>  drivers/acpi/sbs.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
>> index 10a3651..8493603 100644
>> --- a/drivers/acpi/sbs.c
>> +++ b/drivers/acpi/sbs.c
>> @@ -816,7 +816,9 @@ static int acpi_battery_add(struct acpi_sbs *sbs, int id)
>>
>>  static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
>>  {
>> +#ifdef CONFIG_ACPI_SYSFS_POWER || CONFIG_ACPI_PROCFS_POWER
>
> I don't think you can use || operator in ifdef like that... ...Try
> #if defined(...) || (...) instead.
>
>
> --
>  i.
>

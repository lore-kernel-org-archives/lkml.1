Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbYGHMSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbYGHMSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbYGHMSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:18:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:24325 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbYGHMSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=t9S6YICqyqpAQ00ji/WuFZ2CFwhmLQUa3VFgR5EHzc79xQnCXOV+0RTbVRx/XxvC6d
         b2mtIu+z+/uE/I+9MuXUmiaKAOjPdYQA5Dl4A+sYmBAeagYrXgmbgwkT193mfQ31z4ff
         WTkBNH6ZXlQfUhKcdu+VZoKkL/sv3rjJ/aE7k=
Message-ID: <a4423d670807080518g31402f60j2f624a2ac2db03aa@mail.gmail.com>
Date: Tue, 8 Jul 2008 16:18:02 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, jbarnes@virtuousgeek.org,
       ak@linux.intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-next@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: next-0708: build failure at drivers/pci/pci-acpi.c
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael

drivers/pci/pci-acpi.c: In function 'acpi_pci_sleep_wake':
drivers/pci/pci-acpi.c:311: error: implicit declaration of function
'acpi_pm_device_sleep_wake'

drivers/pci/pci-acpi.c:
309-static int acpi_pci_sleep_wake(struct pci_dev *dev, bool enable)
310-{
311:    int error = acpi_pm_device_sleep_wake(&dev->dev, enable);


include/acpi/acpi_bus.h:
381-#ifdef CONFIG_PM_SLEEP
382-int acpi_pm_device_sleep_state(struct device *, int *);
383:int acpi_pm_device_sleep_wake(struct device *, bool);
384-#else /* !CONFIG_PM_SLEEP */
385-static inline int acpi_pm_device_sleep_state(struct device *d, int *p)
386-{
387-    if (p)
388-            *p = ACPI_STATE_D0;
389-    return ACPI_STATE_D3;
390-}
391-#endif /* !CONFIG_PM_SLEEP */

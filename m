Return-Path: <linux-kernel-owner+w=401wt.eu-S1751129AbXBZGgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129AbXBZGgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 01:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXBZGgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 01:36:54 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:32857 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbXBZGgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 01:36:53 -0500
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dmitriy Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: [PATCH] libata: handle ata_pci_device_do_resume() failure while resuming (v2)
References: <87abz4ble1.fsf@sw.ru>
	<20070225220114.c449ef95.randy.dunlap@oracle.com>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Mon, 26 Feb 2007 09:35:50 +0300
In-Reply-To: <20070225220114.c449ef95.randy.dunlap@oracle.com> (Randy Dunlap's message of "Sun, 25 Feb 2007 22:01:14 -0800")
Message-ID: <87vehp4e9l.fsf_-_@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Randy Dunlap <randy.dunlap@oracle.com> writes:

> On Sat, 24 Feb 2007 00:43:18 +0300 Dmitriy Monakhov wrote:
>
>> Since commit:553c4aa630af7bc885e056d0436e4eb7f238579b
>> ata_pci_device_do_resume() can return error code, all callers was updated
>> except this one.
>> 
>> Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
>> ---
>>  drivers/ata/sata_inic162x.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
>> index 31b636f..7933043 100644
>> --- a/drivers/ata/sata_inic162x.c
>> +++ b/drivers/ata/sata_inic162x.c
>> @@ -639,7 +639,10 @@ static int inic_pci_device_resume(struct pci_dev *pdev)
>>  	void __iomem *mmio_base = host->iomap[MMIO_BAR];
>>  	int rc;
>>  
>> -	ata_pci_device_do_resume(pdev);
>> +	rc = ata_pci_device_do_resume(pdev);
>> +	if (rc) {
>> +		return rc;
>
> Either (a) don't use the braces when they are not needed, or
> (b) is it possible to add a meaningful message there, or is that
> done elsewhere?
True. Thanks for correcting me here.
It is't realy necessary print err message because ata_pci_device_do_resume()
already done this. So just remove braces.


 Since commit:553c4aa630af7bc885e056d0436e4eb7f238579b
 ata_pci_device_do_resume() can return error code, all callers was updated
 except this one.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>


--=-=-=
Content-Disposition: inline;
 filename*0*=us-ascii''diff-ms-libata-handle-ata_pci_device_do_resume-fail;
 filename*1*=ure-while-resuming

diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 31b636f..18ac665 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -639,7 +639,9 @@ static int inic_pci_device_resume(struct pci_dev *pdev)
 	void __iomem *mmio_base = host->iomap[MMIO_BAR];
 	int rc;
 
-	ata_pci_device_do_resume(pdev);
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
 		printk("XXX\n");

--=-=-=--


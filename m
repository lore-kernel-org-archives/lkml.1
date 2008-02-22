Return-Path: <linux-kernel-owner+w=401wt.eu-S936746AbYBVBey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936746AbYBVBey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936634AbYBVBec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:34:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:6769 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936624AbYBVBea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=vGbCJVez75yDMcA1lORzipnDiDDFiSLmeNKOCalf1GP9tx1Re8sIS/vKKoanO7H1U/DbIGQK4kllj80xZH+DwXi6daYrUfcsMgEW25JOjORiG3vOUDOXJpGE1SA+NjqUg9jNlEa9llkCwAzxKztQKQxHRMxt1FAJNIcSlxBEF2o=
Message-ID: <47BE26A0.2040708@gmail.com>
Date: Fri, 22 Feb 2008 10:34:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] libata: Register for dock events when the drive is	inside
 a dock station
References: <20080214124048.GB9708@homac.suse.de> <20080214125615.GD9708@homac.suse.de> <47BC5F44.605@garzik.org> <20080221115305.GB5032@homac.suse.de>
In-Reply-To: <20080221115305.GB5032@homac.suse.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If a device/bay is inside a docking station, we need to register for dock
> events additionally to bay events. If a dock event occurs, the dock driver
> will call the appropriate handler (ata_acpi_ap_notify() or
> ata_acpi_dev_notify()) for us.
> 
> Signed-off-by: Holger Macht <hmacht@suse.de>
> ---
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 9e8ec19..563ad72 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -191,20 +191,33 @@ void ata_acpi_associate(struct ata_host *host)
>  		else
>  			ata_acpi_associate_ide_port(ap);
>  
> -		if (ap->acpi_handle)
> +		if (ap->acpi_handle) {
>  			acpi_install_notify_handler (ap->acpi_handle,
>  						     ACPI_SYSTEM_NOTIFY,
>  						     ata_acpi_ap_notify,
>  						     ap);
> +#ifdef CONFIG_ACPI_DOCK_MODULE

Heh, you need

  #if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)

Also, another question.  Is there a way to tell whether the device or
port is connected behind a dock or not?  Just notifying hotplug signal
is fine for hotplugging but to make hot unplug safe for PATA, libata
should be able to tell whether the device is actually gonna go away and
kill it explicitly.

Thanks.

-- 
tejun

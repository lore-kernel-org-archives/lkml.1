Return-Path: <linux-kernel-owner+w=401wt.eu-S933403AbYBBJMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403AbYBBJMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932931AbYBBJJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:09:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:40498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762097AbYBBJJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:09:12 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 4/10] ACPI: register ACPI Fan as generic thermal cooling device
Date: Sat, 2 Feb 2008 04:08:56 -0500
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, sujith.thomas@intel.com
References: <1200556284.2935.124.camel@acpi-sony.sh.intel.com>
In-Reply-To: <1200556284.2935.124.camel@acpi-sony.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802020408.56587.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2008 02:51, Zhang Rui wrote:
> +#ifdef CONFIG_ACPI_PROCFS
>  
>  static struct proc_dir_entry *acpi_fan_dir;
>  
> @@ -167,7 +213,17 @@ static int acpi_fan_remove_fs(struct acp
>  
>         return 0;
>  }
> +#else
> +static int acpi_fan_add_fs(struct acpi_device *device)
> +{
> +       return 0;
> +}
>  
> +static int acpi_fan_remove_fs(struct acpi_device *device)
> +{
> +       return 0;
> +}
> +#endif

commit 3c602840528cf1aa835e6e32d76a0a45936b8e4c
Author: Len Brown <len.brown@intel.com>
Date:   Sat Feb 2 04:05:54 2008 -0500

    ACPI: fan: build fix for CONFIG_ACPI_PROCFS=n
    
    drivers/acpi/fan.c:340: error: ‘acpi_fan_dir’ undeclared (first use in this function)
    
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index f6e8165..48cb705 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -337,10 +337,12 @@ static int __init acpi_fan_init(void)
 	int result = 0;
 
 
+#ifdef CONFIG_ACPI_PROCFS
 	acpi_fan_dir = proc_mkdir(ACPI_FAN_CLASS, acpi_root_dir);
 	if (!acpi_fan_dir)
 		return -ENODEV;
 	acpi_fan_dir->owner = THIS_MODULE;
+#endif
 
 	result = acpi_bus_register_driver(&acpi_fan_driver);
 	if (result < 0) {

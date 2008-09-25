Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbYIYGs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbYIYGs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYIYGsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:48:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:20781 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYIYGst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:48:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=esL+JVT7HAoK2bZirQbdiJUsLwVLmzTTafwsJbi2QNQ4gEw/HrAnVWbya/h4mhnZXK
         UByNCl8L2T2GtGXwyHJs0TUjVAyoYZqF26wcaPNDNJbUlTyeCTfXXtJFqDQabXoO40yN
         qgH77Ofm5gzd/JMSF1yDWRxMK9h3i+mY6CATo=
Message-ID: <86802c440809242348g10939ca2p79b5bd1ce7e5fac0@mail.gmail.com>
Date: Wed, 24 Sep 2008 23:48:31 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86/pci: fix dmar_tbl early_ioremap leak
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
In-Reply-To: <1222324048-13853-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222324048-13853-1-git-send-email-yhlu.kernel@gmail.com>
X-Google-Sender-Auth: eae36ed53d1e677f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 11:27 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> use early_acpi_os_unmap_memory
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> ---
>  drivers/pci/dmar.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/drivers/pci/dmar.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/dmar.c
> +++ linux-2.6/drivers/pci/dmar.c
> @@ -42,6 +42,7 @@
>  LIST_HEAD(dmar_drhd_units);
>
>  static struct acpi_table_header * __initdata dmar_tbl;
> +static acpi_size __initdata dmar_tbl_size;
>
>  static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
>  {
> @@ -296,9 +297,13 @@ static int __init dmar_table_detect(void
>  {
>        acpi_status status = AE_OK;
>
> +       if (dmar_tbl)
> +               early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
> +

need more work..

YH

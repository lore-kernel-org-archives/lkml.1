Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYKKWZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYKKWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYKKWZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:25:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317AbYKKWZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:25:13 -0500
Date: Tue, 11 Nov 2008 14:24:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix argument type for acpi_evaluate_integer in
 acpi_get_physical_pci_device
Message-Id: <20081111142439.b804bdd6.akpm@linux-foundation.org>
In-Reply-To: <200811031216.15690.arvidjaar@mail.ru>
References: <200811031216.15690.arvidjaar@mail.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2008 12:16:13 +0300
Andrey Borzenkov <arvidjaar@mail.ru> wrote:

> Subject: [PATCH] Fix argument type for acpi_evaluate_integer in acpi_get_physical_pci_device
> From: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> CC      drivers/acpi/glue.o
> /home/bor/src/linux-git/drivers/acpi/glue.c: In function 'acpi_get_physical_pci_device':
> /home/bor/src/linux-git/drivers/acpi/glue.c:157: warning: passing argument 4 of 'acpi_evaluate_integer' from incompatible pointer type
> 
> acpi_evaluate_integer takes pointer to unsigned long long as fourth argument
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> ---
> 
>  drivers/acpi/glue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
> index 98c9c76..436c8a3 100644
> --- a/drivers/acpi/glue.c
> +++ b/drivers/acpi/glue.c
> @@ -150,7 +150,7 @@ EXPORT_SYMBOL(acpi_get_physical_device);
>  struct device *acpi_get_physical_pci_device(acpi_handle handle)
>  {
>  	struct device *dev;
> -	long device_id;
> +	unsigned long long device_id;
>  	acpi_status status;
>  
>  	status =

Someone has gone and changed this to `long long', which is still wrong
but which (surprisingly) doesn't seem to generate a compilation
warning.


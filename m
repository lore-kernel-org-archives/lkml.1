Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZFBRa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZFBRa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbZFBRaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:30:17 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:26313 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbZFBRaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:30:16 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH 08/10] ACPI: simplify acpi_pci_irq_add_prt() API
Date: Tue, 2 Jun 2009 11:30:15 -0600
User-Agent: KMail/1.9.10
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20090602152351.7346.48697.stgit@bob.kio> <20090602152516.7346.24236.stgit@bob.kio>
In-Reply-To: <20090602152516.7346.24236.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906021130.15951.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 June 2009 09:25:16 am Alex Chiang wrote:
> A PCI domain cannot change as you descend down subordinate buses, which
> makes the 'segment' argument to acpi_pci_irq_add_prt() useless.
> 
> Change the interface to take a struct pci_bus *, from whence we can derive
> the bus number and segment. Reducing the number of arguments makes life
> simpler for callers.

Nice patch.

> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index 25ddbb6..aa67f72 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -537,8 +537,9 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
>  	 */
>  	status = acpi_get_handle(device->handle, METHOD_NAME__PRT, &handle);
>  	if (ACPI_SUCCESS(status))
> -		result = acpi_pci_irq_add_prt(device->handle, root->id.segment,
> -					      root->id.bus);
> +		result = acpi_pci_irq_add_prt(device->handle,
> +					      pci_find_bus(root->id.segment,
> +							   root->id.bus));

I think you can just do this:

	acpi_pci_irq_add_prt(device->handle, root->bus);

Bjorn

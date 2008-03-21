Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbYCUQRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbYCUQRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYCUQRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:17:41 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:42190 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYCUQRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:17:40 -0400
Date: Fri, 21 Mar 2008 10:17:39 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/16][BUG] ACPI pci_slot: Fix _STA evaluation (Not for
	mainline!)
Message-ID: <20080321161739.GG17292@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com> <47E3356D.6010509@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E3356D.6010509@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Fix the problem that pci slots that doesn't have _STA are not
> detected. If the device doesn't have _STA, we must assume it is always
> there.

Merged, thanks.

/ac

> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> ---
>  drivers/acpi/pci_slot.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.25-rc6/drivers/acpi/pci_slot.c
> ===================================================================
> --- linux-2.6.25-rc6.orig/drivers/acpi/pci_slot.c
> +++ linux-2.6.25-rc6/drivers/acpi/pci_slot.c
> @@ -76,9 +76,8 @@ check_slot(acpi_handle handle, int *devi
>  
>  	if (check_sta_before_sun) {
>  		/* If SxFy doesn't have _STA, we just assume it's there */
> -		acpi_evaluate_integer(handle, "_STA", NULL, &sta);
> -
> -		if (!(sta & ACPI_STA_DEVICE_PRESENT)) {
> +		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
> +		if (ACPI_SUCCESS(status) && !(sta & ACPI_STA_DEVICE_PRESENT)) {
>  			retval = -1;
>  			goto out;
>  		}
> 
> 

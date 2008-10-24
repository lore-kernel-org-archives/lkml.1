Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbYJXBR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbYJXBR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 21:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYJXBRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 21:17:17 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34965 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058AbYJXBRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 21:17:17 -0400
Subject: Re: Oops in ACPI with git latest
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <200810232242.33480.rjw@sisk.pl>
References: <1224791103.3330.37.camel@localhost.localdomain>
	 <200810232242.33480.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 20:17:12 -0500
Message-Id: <1224811033.3330.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 22:42 +0200, Rafael J. Wysocki wrote:
> On Thursday, 23 of October 2008, James Bottomley wrote:
> > ACPI Warning (nseval-0168): Insufficient arguments - method [_OSC] needs 5, found 4 [20080926]
> > ACPI Warning (nspredef-0252): \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, expected 4 [20080926]
> > ACPI Error (nspredef-0163): \_SB_.PCI0._OSC: Missing expected return value [20080926]
> > BUG: unable to handle kernel NULL pointer dereference at 00000000
> Does this patch help?
> 
> ---
>  drivers/pci/pci-acpi.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-acpi.c
> +++ linux-2.6/drivers/pci/pci-acpi.c
> @@ -83,6 +83,9 @@ static acpi_status acpi_run_osc(acpi_han
>  	if (ACPI_FAILURE(status))
>  		return status;
>  
> +	if (!output.pointer)
> +		return AE_NULL_OBJECT;
> +
>  	out_obj = output.pointer;
>  	if (out_obj->type != ACPI_TYPE_BUFFER) {
>  		printk(KERN_DEBUG "Evaluate _OSC returns wrong type\n");

Yes, that seems to fix it, thanks! ... I suppose the ASL error and
warnings need investigating too?

James



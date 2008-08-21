Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbYHUPjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbYHUPjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYHUPjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:39:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:56873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYHUPjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:39:12 -0400
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
From: Kay Sievers <kay.sievers@vrfy.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, Marcel Selhorst <tpm@selhorst.net>,
       Thomas Renninger <trenn@suse.de>, Adam Belay <ambx1@neo.rr.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
In-Reply-To: <200808210914.27516.bjorn.helgaas@hp.com>
References: <200808181540.25286.elendil@planet.nl>
	 <200808211440.27577.rjw@sisk.pl> <1219325336.20723.32.camel@lgn.site>
	 <200808210914.27516.bjorn.helgaas@hp.com>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 17:38:25 +0200
Message-Id: <1219333105.20723.45.camel@lgn.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX184cJJKx1UejwPuOLDSJ+P2yml7sTPQ2PiV1FT
 sqQVfGCwCK7olRyRNYniTp5P6T4JBC6MwLGVVFtGcn28p7lNFU
 UeIPX5A3PCGe+t89qs4/17Er88CAfRv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 09:14 -0600, Bjorn Helgaas wrote:
> On Thursday 21 August 2008 07:28:56 am Kay Sievers wrote:
> > Yeah, we miss to loop over the list. This should fix it. Thanks!
> 
> Thanks for the patch.
> 
> Can somebody elaborate on why we need to add "acpi*" aliases for all
> PNP devices?  That broadens the kernel/user interface, so I'd like
> to understand why we need it.

We already do ACPI module autoloading by MODALIAS for other things than
pnp. ACPI exports the pnp devices with modalias, but the modules do not
have a matching alias, this add them.

PNP has no MODALIAS support at all, and the current pnp-aliases would
not work for the standard modalias method, they would need to change
their format.

The plan is to replace the current pnp modprobe shell script hack in
udev, when ACPI devices load the right modules without any special
userspace mangling.

Thanks,
Kay


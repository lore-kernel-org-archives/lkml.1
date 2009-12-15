Return-Path: <linux-kernel-owner+w=401wt.eu-S1750996AbZLOFDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996AbZLOFDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbZLOFDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:03:15 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:33579 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZLOFDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:03:13 -0500
Subject: Re: linux-next: acpi tree build failure
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091214122013.a869739e.sfr@canb.auug.org.au>
References: <20091214122013.a869739e.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Mon, 14 Dec 2009 21:57:34 -0700
Message-Id: <1260853054.21292.10.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 12:20 +1100, Stephen Rothwell wrote:
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> ERROR: "pnpacpi_protocol" [drivers/char/ipmi/ipmi_si.ko] undefined!
> 
> Caused by commit e80b594fd69039387339e75b4f75c58da74676ae ("PNP: add
> interface to retrieve ACPI device from a PNPACPI device").

Here's the fix:

commit 28b07e816ecc25567c8ff25e5a0c52f57e55b91f
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 14 21:41:17 2009 -0700

    PNP: export pnpacpi_protocol (for pnp_acpi_device() test)
    
    In e80b594f, I added an exported interface, pnp_acpi_device(), but
    I neglected to export the underlying pnpacpi_protocol symbol.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 8dd0f37..5314bf6 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -154,6 +154,7 @@ struct pnp_protocol pnpacpi_protocol = {
 	.resume = pnpacpi_resume,
 #endif
 };
+EXPORT_SYMBOL(pnpacpi_protocol);
 
 static int __init pnpacpi_add_device(struct acpi_device *device)
 {



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbYA3EnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbYA3EnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 23:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYA3EnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 23:43:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:36134 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYA3EnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 23:43:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=eHsCs/EPFmgAjHk88etXVGsaPIM20KqcWu4VXvfp/CAbTNet/6jrLbPL/Dki5U+lYg5ggizyjUuinGCGTEuQRLHW1+85FVQydLxUwblhYfXxwnJ+6IfLoOVJOlFF/Q+xs2GWZsVfGryrPQP19Fpo+/p0MV49MZP110EaPzrg8mM=
Message-ID: <47A00057.9090306@googlemail.com>
Date: Wed, 30 Jan 2008 05:43:03 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       romieu@fr.zoreil.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD FAILURE]2.6.24-git6 build failure on sis190 ethernet driver
References: <479FF1F0.10907@linux.vnet.ibm.com>
In-Reply-To: <479FF1F0.10907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi,
> 
> The 2.6.24-git6 kernel build fails on various x86_64 machines with the build failure
> 
> drivers/net/sis190.c:329: error: sis190_pci_tbl causes a section type conflict
> make[2]: *** [drivers/net/sis190.o] Error 1
> 
> # gcc --version (machine1)
> gcc (GCC) 4.1.1 20070105 (Red Hat 4.1.1-52)
> 
> # gcc --version (machine2)
> gcc (GCC) 4.1.1 20060525 (Red Hat 4.1.1-1)
> 

Heh :) vger.kernel.org does not like emails directly from gmail , it seems =)

( sorry for sending this 3 time now )

The following patch should fix the build failure.

diff --git a/drivers/net/sis190.c b/drivers/net/sis190.c
index b570402..e48e4ad 100644
--- a/drivers/net/sis190.c
+++ b/drivers/net/sis190.c
@@ -326,7 +326,7 @@ static const struct {
 	{ "SiS 191 PCI Gigabit Ethernet adapter" },
 };
 
-static struct pci_device_id sis190_pci_tbl[] __devinitdata = {
+static const struct pci_device_id sis190_pci_tbl[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0190), 0, 0, 0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0191), 0, 0, 1 },
 	{ 0, },


Gabriel

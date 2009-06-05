Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZFEJEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZFEJEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbZFEJDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:03:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40356 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755977AbZFEJDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:03:50 -0400
Date: Fri, 5 Jun 2009 10:05:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grozdan <neutrino8@gmail.com>
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
Message-ID: <20090605100505.41b3b818@lxorguk.ukuu.org.uk>
In-Reply-To: <c5bd819b0906040750w75e0389cod2a03b89ce838d1b@mail.gmail.com>
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
	<4A25F688.9000407@gmail.com>
	<c5bd819b0906030435w466368cbsd48be91a97597437@mail.gmail.com>
	<20090603131407.57c490ed@lxorguk.ukuu.org.uk>
	<c5bd819b0906030552w6f23185etb394f83c8b630e6@mail.gmail.com>
	<20090603140140.491a8ea8@lxorguk.ukuu.org.uk>
	<c5bd819b0906030639o5f9c34ffg500e132d3a0b5117@mail.gmail.com>
	<c5bd819b0906040750w75e0389cod2a03b89ce838d1b@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Adding more information. A user on the openSUSE forum which is trying
> out openSUSE 11.2 milestone 2 (with kernel 2.6.30-rc6-git3) is having
> the same problems. His computer is using the pata_amd driver instead
> of pata_via like mine and he too gets limiting to UDMA33 during boot
> 
> Link: http://forums.opensuse.org/pre-release-beta/415373-hd-speed.html

Different problem. However that Nvidia one it would be worth trying this
so that we just rely upon the ACPI/BIOS data for Nvidia.

diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 33a74f1..c9c5fad 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -424,7 +424,7 @@ static struct ata_port_operations amd133_port_ops = {
 
 static const struct ata_port_operations nv_base_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
-	.cable_detect	= ata_cable_ignore,
+	.cable_detect	= ata_cable_80wire,
 	.mode_filter	= nv_mode_filter,
 	.prereset	= nv_pre_reset,
 	.host_stop	= nv_host_stop,

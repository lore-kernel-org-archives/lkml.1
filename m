Return-Path: <linux-kernel-owner+w=401wt.eu-S2992789AbXCCASQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992789AbXCCASQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 19:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992792AbXCCASQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 19:18:16 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:51360 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992789AbXCCASO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 19:18:14 -0500
Subject: Re: [linux-pm] [PATCH 2/2 -stable] libata: add missing CONFIG_PM
	in LLDs
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Tejun Heo <htejun@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-ide@vger.kernel.org,
       jgarzik@pobox.com, linux-pm@lists.osdl.org, stable@kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20070302084649.GO20322@htj.dyndns.org>
References: <20061122172841.0b90f042@localhost.localdomain>
	 <Pine.LNX.4.60.0702262150460.5079@poirot.grange>
	 <Pine.LNX.4.60.0702282201250.8832@poirot.grange>
	 <Pine.LNX.4.60.0703012305030.7351@poirot.grange>
	 <20070302084530.GN20322@htj.dyndns.org>
	 <20070302084649.GO20322@htj.dyndns.org>
Content-Type: text/plain
Date: Sat, 03 Mar 2007 11:18:14 +1100
Message-Id: <1172881095.18544.108.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2007-03-02 at 17:46 +0900, Tejun Heo wrote:
> Add missing #ifdef CONFIG_PM conditionals around all PM related parts
> in libata LLDs.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  drivers/ata/ahci.c              |   14 ++++++++++++++
>  drivers/ata/ata_generic.c       |    4 ++++
>  drivers/ata/ata_piix.c          |    4 ++++
>  drivers/ata/pata_ali.c          |    6 ++++++
>  drivers/ata/pata_amd.c          |    6 ++++++
>  drivers/ata/pata_atiixp.c       |    4 ++++
>  drivers/ata/pata_cmd64x.c       |    6 ++++++
>  drivers/ata/pata_cs5520.c       |    7 +++++++
>  drivers/ata/pata_cs5530.c       |    6 ++++++
>  drivers/ata/pata_cs5535.c       |    4 ++++
>  drivers/ata/pata_cypress.c      |    4 ++++
>  drivers/ata/pata_efar.c         |    4 ++++
>  drivers/ata/pata_hpt366.c       |    7 ++++++-
>  drivers/ata/pata_hpt3x3.c       |    6 ++++++
>  drivers/ata/pata_it821x.c       |    6 ++++++
>  drivers/ata/pata_jmicron.c      |    4 ++++
>  drivers/ata/pata_marvell.c      |    4 ++++
>  drivers/ata/pata_mpiix.c        |    4 ++++
>  drivers/ata/pata_netcell.c      |    4 ++++
>  drivers/ata/pata_ns87410.c      |    4 ++++
>  drivers/ata/pata_oldpiix.c      |    4 ++++
>  drivers/ata/pata_opti.c         |    4 ++++
>  drivers/ata/pata_optidma.c      |    4 ++++
>  drivers/ata/pata_pdc202xx_old.c |    4 ++++
>  drivers/ata/pata_radisys.c      |    4 ++++
>  drivers/ata/pata_rz1000.c       |    6 ++++++
>  drivers/ata/pata_sc1200.c       |    4 ++++
>  drivers/ata/pata_serverworks.c  |    6 ++++++
>  drivers/ata/pata_sil680.c       |    4 ++++
>  drivers/ata/pata_sis.c          |    4 ++++
>  drivers/ata/pata_triflex.c      |    4 ++++
>  drivers/ata/pata_via.c          |    6 ++++++
>  drivers/ata/sata_sil.c          |    2 ++
>  drivers/ata/sata_sil24.c        |    2 ++
>  34 files changed, 165 insertions(+), 1 deletion(-)
> 
> Index: work1/drivers/ata/ahci.c
> ===================================================================
> --- work1.orig/drivers/ata/ahci.c
> +++ work1/drivers/ata/ahci.c
> @@ -225,10 +225,12 @@ static void ahci_thaw(struct ata_port *a
>  static void ahci_error_handler(struct ata_port *ap);
>  static void ahci_vt8251_error_handler(struct ata_port *ap);
>  static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
> +#ifdef CONFIG_PM
>  static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
>  static int ahci_port_resume(struct ata_port *ap);
>  static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
>  static int ahci_pci_device_resume(struct pci_dev *pdev);

Wouldn't it be simpler to add

#else
#define ahci_port_suspend(port, message) (NULL)

etc (or something similar)?

Regards,

Nigel




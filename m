Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbZA0TU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbZA0TU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 14:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbZA0TUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 14:20:47 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43330 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934AbZA0TUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 14:20:46 -0500
Subject: Re: [PATCH 4/5] bfa: Brocade BFA FC SCSI driver submission
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jing Huang <huangj@brocade.com>
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com
In-Reply-To: <200901271855.n0RItOUA026905@swe37.brocade.com>
References: <200901271855.n0RItOUA026905@swe37.brocade.com>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 19:20:43 +0000
Message-Id: <1233084043.3231.91.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 10:55 -0800, Jing Huang wrote:
> From: Jing Huang <huangj@brocade.com>
> 
> This patch contains Makefile and Kconfig file for scsi and bfa. It is created
> using 2.6.29-rc2 kernel.
> 
> Signed-off-by: Jing Huang <huangj@brocade.com>
> ---
>  drivers/scsi/Kconfig      |    6 ++++++
>  drivers/scsi/Makefile     |    1 +
>  drivers/scsi/bfa/Kconfig  |    6 ++++++
>  drivers/scsi/bfa/Makefile |   25 +++++++++++++++++++++++++
>  4 files changed, 38 insertions(+)
> 
> diff -urpN orig/drivers/scsi/bfa/Kconfig patch/drivers/scsi/bfa/Kconfig
> --- orig/drivers/scsi/bfa/Kconfig	1969-12-31 16:00:00.000000000 -0800
> +++ patch/drivers/scsi/bfa/Kconfig	2009-01-26 17:28:26.000000000 -0800
> @@ -0,0 +1,6 @@
> +config SCSI_BFA_FC
> +	tristate "Brocade BFA Fibre Channel Support"
> +	depends on PCI && SCSI
> +	---help---
> +	Select M for building module
> +

You don't actually need this file: your Kconfig addition to scsi/Kconfig
does this.

> diff -urpN orig/drivers/scsi/bfa/Makefile patch/drivers/scsi/bfa/Makefile
> --- orig/drivers/scsi/bfa/Makefile	1969-12-31 16:00:00.000000000 -0800
> +++ patch/drivers/scsi/bfa/Makefile	2009-01-26 17:28:26.000000000 -0800
> @@ -0,0 +1,25 @@
> +#
> +# Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
> +# All rights reserved
> +# www.brocade.com
> +# 
> +# Linux driver for Brocade Fibre Channel Host Bus Adapter.
> +#
> +# This program is free software; you can redistribute it and/or modify it
> +# under the terms of the GNU General Public License (GPL) Version 2 as
> +# published by the Free Software Foundation
> +#
> +# This program is distributed in the hope that it will be useful, but
> +# WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> +# General Public License for more details.
> +#
> +obj-$(CONFIG_SCSI_BFA_FC) := bfa.o
> +
> +bfa-objs := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o	\
> +	bfad_fwimg.o bfa_fcs.o bfa_core.o bfa_ioc.o bfa_iocfc.o bfa_hw_cb.o	\
> +	bfa_hw_ct.o bfa_fcxp.o bfa_intr.o bfa_timer.o bfa_rport.o bfa_port.o	\
> +	bfa_uf.o bfa_sgpg.o bfa_module.o bfa_ioim.o bfa_itnim.o bfa_fcpim.o	\
> +	bfa_tskim.o bfa_log.o bfa_log_module.o bfa_csdebug.o bfa_sm.o plog.o
> +
> +EXTRA_CFLAGS += -I$(obj) -I$(obj)/include
> diff -urpN orig/drivers/scsi/Kconfig patch/drivers/scsi/Kconfig
> --- orig/drivers/scsi/Kconfig	2009-01-26 17:28:26.000000000 -0800
> +++ patch/drivers/scsi/Kconfig	2009-01-26 17:28:21.000000000 -0800
> @@ -1797,6 +1797,12 @@ config SCSI_SRP
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called libsrp.
>  
> +config SCSI_BFA_FC
> +	tristate "Brocade BFA Fibre Channel Support"
> +	depends on PCI && SCSI

You need also

	select SCSI_FC_ATTRS

> +	---help---
> +	  To compile this driver as a module, choose M here. The module will be called bfa

The help isn't really very helpful.  What usually goes here is something
like

This bfa driver supports all Brocade PCI and PCIe fibre channel adapters

(and if that's not true, give a list of the supported ones or the family
name).

James



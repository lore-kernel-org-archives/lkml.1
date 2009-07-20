Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbZGTHXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbZGTHXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 03:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZGTHXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 03:23:36 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:57513 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbZGTHXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 03:23:35 -0400
Date: Mon, 20 Jul 2009 09:23:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@HansenPartnership.com, kgudipat@brocade.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       rvadivel@brocade.com, vravindr@brocade.com, xmzhang@brocade.com
Subject: Re: [PATCH 4/5] bfa: Brocade BFA FC SCSI driver (make)
Message-ID: <20090720072334.GB6340@merkur.ravnborg.org>
References: <200907200626.n6K6QsTD011626@swe57.brocade.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907200626.n6K6QsTD011626@swe57.brocade.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 19, 2009 at 11:26:54PM -0700, Jing Huang wrote:
> From: Jing Huang <huangj@brocade.com>
> 
> This patch contains Makefile and Kconfig file for scsi and bfa.
> 
> Signed-off-by: Jing Huang <huangj@brocade.com>
> diff -urpN orig/drivers/scsi/bfa/Makefile patch/drivers/scsi/bfa/Makefile
> --- orig/drivers/scsi/bfa/Makefile	1969-12-31 16:00:00.000000000 -0800
> +++ patch/drivers/scsi/bfa/Makefile	2009-07-19 17:48:15.000000000 -0700
> @@ -0,0 +1,30 @@
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

A big boilerplate for a simple kbuild file...

> +obj-$(CONFIG_SCSI_BFA_FC) := bfa.o
OK - I assume the name of the module is remotely aligned with
what other scsi drivers uses.
That is - there is no scsi prefix or anything else that says this is
a scsi driver. If this is gennerally not used then you do not need it either.

> +
> +bfa-objs := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o bfad_fwimg.o \
> +	bfa_core.o bfa_ioc.o bfa_iocfc.o bfa_aen.o bfa_fcxp.o bfa_lps.o \
> +	bfa_hw_cb.o bfa_hw_ct.o bfa_intr.o bfa_timer.o bfa_rport.o \
> +	bfa_fcport.o bfa_port.o bfa_uf.o bfa_sgpg.o bfa_module.o bfa_ioim.o \
> +	bfa_itnim.o bfa_fcpim.o bfa_tskim.o bfa_log.o bfa_log_module.o \
> +	bfa_csdebug.o bfa_sm.o plog.o fcbuild.o fabric.o fcpim.o vfapi.o \
> +	fcptm.o bfa_fcs.o bfa_fcs_port.o bfa_fcs_uf.o bfa_fcs_lport.o \
> +        fab.o fdmi.o ms.o ns.o scn.o loop.o lport_api.o n2n.o rport.o \
> +        rport_api.o rport_ftrs.o vport.o

1) Please us:
bfa-y := bfad.o ....

This allows you to later use:
bfa-$(SCSI_BFA_FEATURE) += bfa_feature.o


2) I personally prefer to avoid the line continuation.
   So something like this would be *my* style:

   bfa-y := bfad.o bfad_intr.o bfad_os.o bfad_im.o

   # IO stuff
   bfa-y += bfa_ioc.o bfa_iocfc.o

   # HW near
   bfa-y += bfa_hw_cb.o bfa_hw_ct.o bfa_intr.o bfa_timer.o
   bfa-y += bfa_rport.o bfa_fcport.o bfa_port.o

[Understand the concept - I selected filenames almost randomly]

> +
> +EXTRA_CFLAGS += -I$(obj) -I$(obj)/include -I$(obj)/include/cna

Please use:
ccflags-y := -I$(obj)/include -I$(obj)/include/cna

I do not see why you need "-I$(obj)" - so I left it out on purpose.
It should only be needed if you generate files.


	Sam

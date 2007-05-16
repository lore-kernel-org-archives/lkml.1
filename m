Return-Path: <linux-kernel-owner+w=401wt.eu-S1761295AbXEPIIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295AbXEPIIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759081AbXEPIII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:08:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756815AbXEPIIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:08:05 -0400
Date: Wed, 16 May 2007 01:04:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
Message-Id: <20070516010459.0435d71c.akpm@linux-foundation.org>
In-Reply-To: <464AB9B0.9070205@garzik.org>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	<20070516150629.2c6880c5.kamezawa.hiroyu@jp.fujitsu.com>
	<464AB9B0.9070205@garzik.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 03:58:40 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Tue, 15 May 2007 20:19:14 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> >> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
> >>
> >>
> >> - I found some time to look into some writeback problems in
> >>   fs/fs-writeback.c.  The results were ugly.  There are a pile of fixes here
> >>   but more work (mainly testing) needs to be done.
> >>
> > 
> > If CONFIG_SCSI=y && CONFIG_ATA=n, 
> > 
> > ==
> > ERROR: "ata_sas_slave_configure" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_port_disable" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_sas_port_init" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_sas_port_stop" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_sas_port_start" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_sas_port_alloc" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_noop_qc_prep" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_tf_to_fis" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_noop_dev_select" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_tf_from_fis" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_host_init" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_sas_queuecmd" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_sas_port_destroy" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_scsi_ioctl" [drivers/scsi/libsas/libsas.ko] undefined!
> > ERROR: "ata_qc_complete" [drivers/scsi/libsas/libsas.ko] undefined!
> 
> Looks like SAS needs to require CONFIG_ATA...
> 

Yes, but it seems wrong to disable all of libsas if !ATA.  Only sas_ata.o
should depend on that.

Darrick, is there any point in me carrying this tree?  It doesn't appear to
be a hotbed of activity...

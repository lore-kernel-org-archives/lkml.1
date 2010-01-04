Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855Ab0ADVzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab0ADVzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016Ab0ADVzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:55:11 -0500
Received: from mail.gmx.net ([213.165.64.20]:41771 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751883Ab0ADVzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:55:10 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+ArJE0Fv+A0PMJvBM1EuTNkVlZeevzBPSrEhdFjX
	zk5JBNgf9OWVXC
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: patch scsi-mpt2sas-add-missing-initialization-of-scsih_cmds.patch added to 2.6.32-stable tree
Date: Mon, 4 Jan 2010 22:55:02 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-2.slh.4-sidux-amd64; KDE/4.3.4; x86_64; ; )
Cc: kashyap.desai@lsi.com, gregkh@suse.de, James.Bottomley@suse.de,
       stable@kernel.org
References: <12626340131357@kroah.org>
In-Reply-To: <12626340131357@kroah.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001042255.07139.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Monday 04 January 2010, gregkh@suse.de wrote:
> This is a note to let you know that we have just queued up the patch titled
> 
>     Subject: SCSI: mpt2sas: add missing initialization of scsih_cmds
> 
> to the 2.6.32-stable tree.  Its filename is
> 
>     scsi-mpt2sas-add-missing-initialization-of-scsih_cmds.patch

Adding this patch to 2.6.32 (and likely 2.6.31 as well) breaks building the
current stable queue:

  LD      drivers/scsi/mpt2sas/built-in.o
  CC [M]  drivers/scsi/mpt2sas/mpt2sas_base.o
drivers/scsi/mpt2sas/mpt2sas_base.c: In function 'mpt2sas_base_attach':
drivers/scsi/mpt2sas/mpt2sas_base.c:3500: error: 'struct MPT2SAS_ADAPTER' has no member named 'scsih_cmds'
drivers/scsi/mpt2sas/mpt2sas_base.c:3501: error: 'struct MPT2SAS_ADAPTER' has no member named 'scsih_cmds'
drivers/scsi/mpt2sas/mpt2sas_base.c:3502: error: 'struct MPT2SAS_ADAPTER' has no member named 'scsih_cmds'
make[6]: *** [drivers/scsi/mpt2sas/mpt2sas_base.o] Error 1
make[5]: *** [drivers/scsi/mpt2sas] Error 2

> A git repo of this tree can be found at 
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> 
> From d685c262083dcd5fd98b7499b22a377a3225229c Mon Sep 17 00:00:00 2001
> From: Kashyap, Desai <kashyap.desai@lsi.com>
> Date: Tue, 17 Nov 2009 13:16:37 +0530
> Subject: SCSI: mpt2sas: add missing initialization of scsih_cmds
> 
> From: Kashyap, Desai <kashyap.desai@lsi.com>
> 
> commit d685c262083dcd5fd98b7499b22a377a3225229c upstream.
> 
> Internal command scsih_cmds init is included in mpt2sas_base_attach.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -3583,6 +3583,11 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
>  	ioc->transport_cmds.status = MPT2_CMD_NOT_USED;
>  	mutex_init(&ioc->transport_cmds.mutex);
>  
> +	/* scsih internal command bits */
> +	ioc->scsih_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
> +	ioc->scsih_cmds.status = MPT2_CMD_NOT_USED;
> +	mutex_init(&ioc->scsih_cmds.mutex);
> +

As it seems, the scsih struct member of MPT2SAS_ADAPTER was only added to 
drivers/scsi/mpt2sas/mpt2sas_base.h during the 2.6.33 merge window, so 
this patch doesn't seem to be necessary for <2.6.33-rcX.

>  	/* task management internal command bits */
>  	ioc->tm_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
>  	ioc->tm_cmds.status = MPT2_CMD_NOT_USED;

Regards
	Stefan Lippers-Hollmann

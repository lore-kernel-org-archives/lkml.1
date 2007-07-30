Return-Path: <linux-kernel-owner+w=401wt.eu-S934773AbXG3L0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934773AbXG3L0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 07:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbXG3L0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 07:26:37 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:64072 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbXG3L0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 07:26:36 -0400
Date: Mon, 30 Jul 2007 13:26:34 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/partitions/check.c: add_partition() warning fixes
 (take 3)
Message-ID: <20070730132634.6b7f3696@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070730111638.GA27573@kernel.sg>
References: <20070730111638.GA27573@kernel.sg>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007 19:16:38 +0800,
Eugene Teo <eugeneteo@kernel.sg> wrote:


> +err_out_del_link:
> +	sysfs_remove_link(&p->kobj, "subsystem");
> +err_out_del_uevent:
> +	if (!disk->part_uevent_suppress)
> +		kobject_uevent(&p->kobj, KOBJ_REMOVE);

You're missing kobject_del() here...

> +err_out:
> +	kobject_put(&p->kobj);
>  }
> 
>  static char *make_block_name(struct gendisk *disk)
> 


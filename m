Return-Path: <linux-kernel-owner+w=401wt.eu-S933302AbXG3Kas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302AbXG3Kas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 06:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbXG3Kal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 06:30:41 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:61804 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbXG3Kak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 06:30:40 -0400
Date: Mon, 30 Jul 2007 12:30:45 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/partitions/check.c: add_partition() warning fixes
 (take 2)
Message-ID: <20070730123045.4a3f859c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070730094755.GA25285@kernel.sg>
References: <20070730094755.GA25285@kernel.sg>
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

On Mon, 30 Jul 2007 17:47:55 +0800,
Eugene Teo <eugeneteo@kernel.sg> wrote:

> +err_out_del_link:
> +	sysfs_remove_link(&p->kobj, "subsystem");
> +err_out_del_kobj:
> +	if (!disk->part_uevent_suppress)
> +		kobject_uevent(&p->kobj, KOBJ_REMOVE);
> +	kobject_put(&p->kobj);
> +err_out:
> +	kfree(p);
>  }

No, this is wrong. You need to move the put behind err_out and remove
the kfree. (The release function will take care of p.)

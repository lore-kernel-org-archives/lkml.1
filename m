Return-Path: <linux-kernel-owner+w=401wt.eu-S1760392AbXINMGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbXINMGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbXINMGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:06:23 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:52618 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbXINMGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:06:22 -0400
Date: Fri, 14 Sep 2007 14:06:21 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs: spit a warning to users when they try to create a
 duplicate sysfs file
Message-ID: <20070914140621.77054e9d@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070913234118.GH10856@kroah.com>
References: <20070913233751.GA10856@kroah.com>
	<20070913234118.GH10856@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 16:41:18 -0700,
Greg KH <greg@kroah.com> wrote:


>  int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
>  {
> -	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
> +	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name)) {
> +		printk(KERN_WARNING, "sysfs: duplicate filename '%s' "

Stray ',' here ------------------->^
> +		       "can not be created\n", sd->s_name);
> +		WARN_ON(1);
>  		return -EEXIST;
> +	}
>

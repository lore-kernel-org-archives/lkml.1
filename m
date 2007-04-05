Return-Path: <linux-kernel-owner+w=401wt.eu-S1767125AbXDEP6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767125AbXDEP6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767126AbXDEP6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:58:06 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:22314 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767125AbXDEP6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:58:02 -0400
Date: Thu, 5 Apr 2007 18:00:16 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       viro@zeniv.linux.org.uk
Subject: Re: [-mm3 PATCH] (Retry) Check the return value of kobject_add and
 etc.
Message-ID: <20070405180016.5099e0cd@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070405152732.GA5569@localhost.localdomain>
References: <2375c9f90704010032r119f4a1eqb24dd611d5ecd943@mail.gmail.com>
	<20070402130128.707c8c19@gondolin.boeblingen.de.ibm.com>
	<20070405045410.GA4692@localhost.localdomain>
	<20070405111142.4723035f@gondolin.boeblingen.de.ibm.com>
	<20070405144409.GA5294@localhost.localdomain>
	<20070405170514.481b765f@gondolin.boeblingen.de.ibm.com>
	<20070405152732.GA5569@localhost.localdomain>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007 23:27:32 +0800,
WANG Cong <xiyou.wangcong@gmail.com> wrote:

> Thank you very much! I know. So I should replace all kfree with kobject_put, like this one:
> 
> -	sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem");
> +	if (sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem")) {
> +		kobject_uevent(&p->kobj, KOBJ_REMOVE);
> +		kobject_del(&p->kobj);
> +		kobject_put(&p->kobj);
> +		return;
> +	}
> 
> Is that all right?
> 

Yes, or use kobject_unregister().

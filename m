Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbXCaQGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbXCaQGI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbXCaQGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:06:08 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:41351 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbXCaQGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:06:05 -0400
Date: Sat, 31 Mar 2007 18:08:06 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Message-ID: <20070331180806.55d572c8@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <460DD1B0.4080605@gmail.com>
References: <460CDBA6.5030608@gmail.com>
	<20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>
	<460D0E78.3040200@gmail.com>
	<20070330154042.4c7deb72@gondolin.boeblingen.de.ibm.com>
	<460D178F.4000500@gmail.com>
	<20070330165251.7beffc7c@gondolin.boeblingen.de.ibm.com>
	<460D27E3.2050602@gmail.com>
	<20070330213101.7aa7babf@gondolin.boeblingen.de.ibm.com>
	<460DD1B0.4080605@gmail.com>
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

On Sat, 31 Mar 2007 12:12:48 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> > Hm, but as long as dk0 is registered, it can be looked up and someone
> > could get a reference on it.
> 
> Yeah, exactly.  That's why any getting any kobject reference backed by a
> module must be accompanied by try_module_get().
> 
> int mydrv_get_dk(struct dk *dk)
> {
> 	rc = try_module_get(mydrv);
> 	if (rc)
> 		return rc;
> 	kobject_get(&dk->kobj);
> 	return 0;
> }

This works if the caller always knows which module to grab (I was
thinking about some tree-walking code).

> Exactly, in that case, module reference count must not be zero.  You and
> I are saying the same thing.  Why are we running in circle?

I hope we're not, it just makes one dizzy :)

I'll think some more about it...

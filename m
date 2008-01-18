Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbYARKXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbYARKXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbYARKXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:23:43 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:28672 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbYARKXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:23:42 -0500
Date: Fri, 18 Jan 2008 11:23:37 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: "Gabor Gombas" <gombasg@sztaki.hu>, "Tejun Heo" <htejun@gmail.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, kay.sievers@vrfy.org,
       "Greg KH" <greg@kroah.com>, "Marcel Holtmann" <marcel@holtmann.org>,
       davem@davemloft.net
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080118112337.0b457c49@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080118101933.258bfae9@gondolin.boeblingen.de.ibm.com>
References: <20080108133215.GA15814@boogie.lpds.sztaki.hu>
	<20080111230929.GA7052@boogie.lpds.sztaki.hu>
	<a8e1da0801132305s4f0c3d7asa268382bb6e44777@mail.gmail.com>
	<20080114135228.6b9a8da2@gondolin.boeblingen.de.ibm.com>
	<20080115015741.GB2780@darkstar.te-china.tietoenator.com>
	<20080116010205.GA2970@darkstar.te-china.tietoenator.com>
	<20080116230646.GB6715@boogie.lpds.sztaki.hu>
	<a8e1da0801162324r2cd82684iede3fc8c2f8c391c@mail.gmail.com>
	<20080117081504.GA3123@darkstar.te-china.tietoenator.com>
	<20080117124259.19a88129@gondolin.boeblingen.de.ibm.com>
	<a8e1da0801171937r92a1c32l116315a76f334776@mail.gmail.com>
	<20080118101933.258bfae9@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 10:19:33 +0100,
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> > 
> > 1314         if (IS_ERR(new_parent_kobj)) {
> > 1315                 error = PTR_ERR(new_parent_kobj);
> > 1316                 put_device(new_parent);
> > 1317                 goto out;
> > 1318         }
> > 1319         pr_debug("DEVICE: moving '%s' to '%s'\n", dev->bus_id,
> > 1320                  new_parent ? new_parent->bus_id : "<NULL>");
> > 1321         error = kobject_move(&dev->kobj, new_parent_kobj);
> > 1322         if (error) {
> > 1323                 put_device(new_parent);
> > 
> > imagine new_parent is NULL, then the new_parent_kobj should be put
> 
> No, we would need a put_device_parent() (crappy name) which puts the
> reference iff get_device_parent() grabbed it.

And looking at Greg's patchset, it has cleanup_device_parent(), which
does just that. But it is only called in device_del(), not when
device_move() has errors.

(get_device_parent() also always returns a pointer to a kobject or
NULL, so we can get rid of those IS_ERR() checks in setup_parent() and
device_move() as well.)

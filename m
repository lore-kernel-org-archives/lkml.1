Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbXJJJLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbXJJJLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 05:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbXJJJLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 05:11:23 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:57604 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbXJJJLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 05:11:21 -0400
Date: Wed, 10 Oct 2007 11:11:21 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Roland Dreier <rdreier@cisco.com>, Tejun Heo <htejun@gmail.com>,
       ebiederm@xmission.com, stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver
 model
Message-ID: <20071010111121.79a46c9f@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071009232804.GA22010@kroah.com>
References: <11902755392688-git-send-email-htejun@gmail.com>
	<20070925221736.GA3566@kroah.com>
	<46FB956B.8000205@gmail.com>
	<20071005061812.GA16914@kroah.com>
	<4705EF30.8010002@gmail.com>
	<20071009112901.6d4fa19d@gondolin>
	<20071009222638.GD21228@kroah.com>
	<adar6k3g9iw.fsf@cisco.com>
	<20071009232804.GA22010@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007 16:28:04 -0700,
Greg KH <greg@kroah.com> wrote:

> On Tue, Oct 09, 2007 at 04:20:39PM -0700, Roland Dreier wrote:
> >  > > - relaying implementation details to userspace so that they cannot be
> >  > > easily changed. We would need to allow kobjects not showing up in sysfs
> >  > > and making symlinks a sysfs facility not relying on kobjects to help
> >  > > there.
> >  > 
> >  > Huh?  Why would you want a kobject to not show up in sysfs?
> > 
> > I think the text you replied to explained it perfectly: becase you
> > don't want internal implementation details to be exposed the userspace
> > and become an unchangeable part of the kernel/userspace interface.
> 
> But a kobject represents "something" in the kernel.  If it's there, then
> it shows up in sysfs.  But if it isn't, or it changes somehow, then it
> no longer is in sysfs, which is fine, and your userspace tools have to
> be able to handle that by virtue of the rules of how to use sysfs from
> userspace.

The rules for using sysfs information are currently only laid out for
the driver model. We would need similar rules for every other user of
kobjects.

This only works if we make the following the general rules:

- You may not rely on any information in sysfs to be present.
- Exceptions to that rule are documented for that special user of sysfs.

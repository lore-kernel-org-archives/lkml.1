Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbYIRHHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbYIRHHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYIRHHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:07:38 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:43185 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbYIRHHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:07:37 -0400
Date: Thu, 18 Sep 2008 09:07:05 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg K-H <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]sysfs: Don't emit a warning when sysfs_rename_link()
 fails.
Message-ID: <20080918090705.6985cced@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <m1r67i61rh.fsf@frodo.ebiederm.org>
References: <20080917130805.6260ba9c@gondolin.boeblingen.de.ibm.com>
	<m1r67i61rh.fsf@frodo.ebiederm.org>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 11:55:14 -0700,
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Cornelia Huck <cornelia.huck@de.ibm.com> writes:
> 
> > Hi Greg, hi Eric,
> >
> > the recent sysfs tagged directory changes switched device_rename() to
> > sysfs_rename_link() - which is a good thing but AFAICS re-introduces
> > the scary warnings when a netdevice is renamed to something that
> > already exists (which I tried to fix with
> > 36ce6dad6e3cb3f050ed41e0beac0070d2062b25).
> 
> A netdevice can not be renamed to something that already exists, correctly
> and still emit warnings.  Either it is a noop rename in which case
> the fact that we delete the link before creating it will avoid warnings.

Sure, that case is fine.

> Or we are actually using a conflicting name.  In which case it is a
> real and valid problem. 

Which may be in userspace as well. In the past the networking folks
were unhappy about the sysfs warning, claiming that failures should
rather be handled in their layer.

> The netdev layer especially since the
> networking layer already has validated that the rename is valid
> before calling device_rename.

Does it? Or do I just don't get it because of lack of coffee?

> 
> > The following patch switches sysfs_rename_link() to non-warning symlink
> > creation again. It is on top of the current driver core series.
> 
> We don't need this.  Using the non-warning symlink creation is unnecessary.
> Using non-warning symlink creation hides real errors.

For most cases, yes.

> 
> In practice any errors that show up will be errors in sysfs, because
> the network subsystem validates everything before calling us.

I was under the impression that no checks are done if the rename is
triggered via ioctl. And it makes more sense to have the caller of the
ioctl get an error than to spit a sysfs warning.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbXJJJFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbXJJJFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 05:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbXJJJFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 05:05:36 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:1621 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbXJJJFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 05:05:35 -0400
Date: Wed, 10 Oct 2007 11:05:11 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Tejun Heo <htejun@gmail.com>, ebiederm@xmission.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver
 model
Message-ID: <20071010110511.216c8aae@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071009222638.GD21228@kroah.com>
References: <11902755392688-git-send-email-htejun@gmail.com>
	<20070925221736.GA3566@kroah.com>
	<46FB956B.8000205@gmail.com>
	<20071005061812.GA16914@kroah.com>
	<4705EF30.8010002@gmail.com>
	<20071009112901.6d4fa19d@gondolin>
	<20071009222638.GD21228@kroah.com>
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

On Tue, 9 Oct 2007 15:26:38 -0700,
Greg KH <greg@kroah.com> wrote:

> > - relaying implementation details to userspace so that they cannot be
> > easily changed. We would need to allow kobjects not showing up in sysfs
> > and making symlinks a sysfs facility not relying on kobjects to help
> > there.
> 
> Huh?  Why would you want a kobject to not show up in sysfs?

If we consider everything that shows up in sysfs as API, we cannot go
ahead and change it without risking userspace breakage. The hierarchy
of objects may very well be an "implementation detail". Otherwise, we
would need to lay out for every user of the kobject infrastructure
which information userspace can rely on (like it is documented for the
driver model).

> And yes, I agree we could use some more "automatic" help in regards to
> symlinks in sysfs when we change kobjects around.  That would make
> things simpler for the kobject core.

Yes, non-automatic symlink handling is a large source of pain and
errors. They should probably be tied to sysfs_dirents instead of
kobjects.

> > > Removing kobject from the interface doesn't change anything about this.
> > 
> > Hm. Currently you have a file<->attribute correlation. This would
> > change if you allow non-attribute files.
> 
> I don't want to have non-attribute files, that's my main point here.

That's what I tried to say as well :)

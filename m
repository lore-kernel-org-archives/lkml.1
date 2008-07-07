Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYGGLmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYGGLmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYGGLlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:41:51 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:22528 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYGGLlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:41:49 -0400
Date: Mon, 7 Jul 2008 13:41:01 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 00/15] sysfs support for namespaces
Message-ID: <20080707134101.518734a9@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <m1tzf339ny.fsf@frodo.ebiederm.org>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	<20080618170731.002784342@theryb.frec.bull.fr>
	<485F04E1.70204@gmail.com>
	<m1y74svtff.fsf@frodo.ebiederm.org>
	<486706C9.9040303@gmail.com>
	<m18wwmsqdv.fsf@frodo.ebiederm.org>
	<4869D314.5030403@gmail.com>
	<m1ej6enep7.fsf@frodo.ebiederm.org>
	<486A0751.9080602@gmail.com>
	<m1wsk5hjm0.fsf@frodo.ebiederm.org>
	<486AF4FA.8020805@gmail.com>
	<m1ej6d9c2r.fsf@frodo.ebiederm.org>
	<486B060C.7030607@gmail.com>
	<m14p78s02q.fsf@frodo.ebiederm.org>
	<486C4515.1070007@gmail.com>
	<m1hcb7o8lv.fsf@frodo.ebiederm.org>
	<486CB051.5000507@fr.ibm.com>
	<m14p77m9uy.fsf@frodo.ebiederm.org>
	<486CF71F.5090405@gmail.com>
	<m1y74iiidz.fsf_-_@frodo.ebiederm.org>
	<m1tzf339ny.fsf@frodo.ebiederm.org>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Jul 2008 21:42:57 -0700,
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> > These patches are based off of 2.6.26-rc8 + the -gregkh tree from
> > last night.  Hopefully that means they apply -mm -gregkh and
> > -linux-next.
> 
> A quick update.   My patchset conflicts with the recently added
>   driver-core-suppress-sysfs-warnings-for-device_rename.patch
> 
> > driver core: Suppress sysfs warnings for device_rename().
> > 
> > Renaming network devices to an already existing name is not
> > something we want sysfs to print a scary warning for, since the
> > callers can deal with this correctly. So let's introduce
> > sysfs_create_link_nowarn() which gets rid of the common warning.
> 
> This patch is unnecessary as that path is never exercised anymore.
> as: dev_change_name returns early in the case of a noop rename.

My impression was that the networking folks didn't want any warnings for
renaming failures, not just not for renaming a device to the same name.

> 
> In addition my introduction sysfs_rename_link handles this case
> cleanly by first removing the old link and then creating the new
> link.  Preventing false positives when the link names are the same.

sysfs_rename_link() looks cleaner, I agree.

> 
> So it should be safe to drop Cornelia patch without a reoccurance
> of scary errors.

Hm, the description looks badly worded - I unfortunately left the old
text unchanged when I respun the patch :( The patch re-introduces the
warning in sysfs_add_one() which had been removed in the meanwhile and
makes device_rename() use a non-warning version. I still think we want
a warning for the general case since this is usually caused be some
problems in the calling code (and the alternative would be to add
checks to all callers.)

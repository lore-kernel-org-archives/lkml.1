Return-Path: <linux-kernel-owner+w=401wt.eu-S1765780AbXHOPVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765780AbXHOPVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 11:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760926AbXHOPVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 11:21:06 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:11148 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761319AbXHOPVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 11:21:05 -0400
Date: Wed, 15 Aug 2007 17:21:33 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Florin Iucha <florin@iucha.net>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Randy. Dunlap" <rdunlap@xenotime.net>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
 v2.6.23-rc3-50-g28e8351
Message-ID: <20070815172133.4f2eeda8@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46C313B3.4030700@gmail.com>
References: <Pine.LNX.4.44L0.0708151033270.3895-100000@iolanthe.rowland.org>
	<46C313B3.4030700@gmail.com>
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

On Wed, 15 Aug 2007 23:54:43 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Alan Stern wrote:
> > I think we can simply remove the error message.  There's no obvious 
> > reason why sysfs_remove_bin_file() should complain about attempts to 
> > remove a nonexistent file; sysfs_remove_file() doesn't.
> > 
> > This patch will get rid of the annoying error messages.  It won't do 
> > anything about your keyboard's tendency to spontaneously stop working, 
> > alas.
> 
> Agreed but I think sysfs_remove_bin_file() should relay the return value
> from sysfs_has_and_remove() to the caller.

Three comments:

- Randy made sysfs_remove_bin_file() return void in commit
995982ca79d9262869513948ec7c540f32035491.

- For symmetry reasons, sysfs_remove_file() should then also pass the
return value on.

- I'm not sure who wants to care whether they removed an existing or
non-existing file. But maybe I'm just unimaginative.

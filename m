Return-Path: <linux-kernel-owner+w=401wt.eu-S1764295AbXE2H55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764295AbXE2H55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 03:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXE2H5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 03:57:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51338 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbXE2H5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 03:57:48 -0400
Subject: Re: 2.6.22-rc2-mm1
From: Kay Sievers <kay.sievers@vrfy.org>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Tilman Schmidt <tilman@imap.cc>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
In-Reply-To: <20070528192224.0cf237d0@gondolin.boeblingen.de.ibm.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	 <46585953.80200@imap.cc>
	 <20070526090117.dda72286.akpm@linux-foundation.org>
	 <465A033C.3070400@imap.cc>
	 <3ae72650705271541o2c3755edwdc769883e79820e5@mail.gmail.com>
	 <20070528192224.0cf237d0@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Tue, 29 May 2007 09:56:45 +0200
Message-Id: <1180425405.7208.15.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+r7S+hN3I4zzm6MUdthSrFZU54Ujbjrz5t2+U
 a6ovX80ic9x3xwG3J2N+R0J2ehE7v71uuFY+UPkYEXIEznAXW4
 c0jkhVtO2w1hEo74IO9+VZZVNl3MJv6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-28 at 19:22 +0200, Cornelia Huck wrote: 
> On Mon, 28 May 2007 00:41:19 +0200,
> "Kay Sievers" <kay.sievers@vrfy.org> wrote:
> 
> > Cornelia,
> > in the patch is:
> >   +	if (dev->kobj.parent == &dev->class->subsys.kobj)
> >   +		return 0;
> > 
> > which will skip the creation of the "device"-link, right?
> 
> Uh, looking at the code again, this doesn't seem to be what I wanted :(
> 
> > But still, I don't think the transaction-style of error handling is
> > what we want, it's for some critical subsystems the equivalent of
> > adding PANIC(), and this just for a failing symlink-creation. I think
> > we just want to print the to the logs, and not let the whole core
> > device registration fail entirely.
> 
> Hm, but failure to create a symlink usually signifies something's really
> wrong (no memory, or an object is there which shouldn't)?

Sure, but this is core code, which is used by _all_ drivers and _all_
devices. Subsystems can decide to panic if this appropriate, but generic
core code should probably not make such decisions.

With this change, a single failing symlink (or attribute) for a
scsi/ide/block/... device may crash the whole box during bootup. I'm not
sure that this is what we want.

It's a failure that should be logged (the patch doesn't even add that),
but there is probably no reason to refuse the creation of a device, if
something non-vital like a symlink or attribute fails to be created.

Thanks,
Kay


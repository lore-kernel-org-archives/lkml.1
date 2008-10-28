Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbYJ1XzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbYJ1XzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYJ1XzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:55:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39846 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbYJ1XzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:55:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
Date: Wed, 29 Oct 2008 00:59:37 +0100
User-Agent: KMail/1.9.9
Cc: ncunningham@crca.org.au, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1224886068.6478.21.camel@nigel-laptop> <200810282321.59041.rjw@sisk.pl> <E1Kuxsg-0006PR-Tr@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Kuxsg-0006PR-Tr@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810290059.38411.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 29 of October 2008, Miklos Szeredi wrote:
> On Tue, 28 Oct 2008, Rafael J. Wysocki wrote:
> > On Tuesday, 28 of October 2008, Miklos Szeredi wrote:
> > > I would prefer a freezer-less solution.  Suspend to ram doesn't need
> > > the freezer,
> > 
> > Well, yes it does.  And it will in forseeable future, AFAICS.
> 
> Umm, OK.  Last I remember everybody agreed that there's absolutely no
> reason why processes need to be frozen, and the only important thing
> is that drivers are not twiddling the hardware during suspend, and
> this can usually easily be solved on the subsystem level.

Well, this turned out not to be the case in the meantime.

In fact to handle that without the freezer we'd have to synchronize every
driver's suspend/resume callbacks with every possible way in which
applications can access the device for regular I/O (for example for PCI devices
this means any I/O other than configuration space accesses).

While this is possible in theory, I don't see this happening any time soon,
especially that we're going to keep the bar for accepting new drivers
relatively low.

Thanks,
Rafael

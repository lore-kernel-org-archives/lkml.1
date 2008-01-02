Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbYABFrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbYABFrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 00:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYABFrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 00:47:10 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:39799 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYABFrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 00:47:08 -0500
Subject: Re: [PATCH 1/3] ide: use MODULE_VERSION()
From: Jon Masters <jonathan@jonmasters.org>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@kernel.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080102044620.GB10762@auslistsprd01.us.dell.com>
References: <200801011840.38757.bzolnier@gmail.com>
	 <20080101175333.GA27566@does.not.exist>
	 <200801011933.43930.bzolnier@gmail.com>
	 <1199241156.3300.55.camel@perihelion>
	 <20080102044620.GB10762@auslistsprd01.us.dell.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Wed, 02 Jan 2008 00:46:30 -0500
Message-Id: <1199252790.3300.77.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-01 at 22:46 -0600, Matt Domsch wrote:
> On Tue, Jan 01, 2008 at 09:32:36PM -0500, Jon Masters wrote:
> > On Tue, 2008-01-01 at 19:33 +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> > > On the second thought: maybe we will be better off with limiting
> > > MODULE_VERSION() to the device drivers and the IDE core module for now,
> > > and just removing all these private version numbers from host drivers
> > > (with one or two exceptions they are not printed or exported currently,
> > > moreover exceptions are the cases like stale version numbers from 199x)?
> > 
> > Things like checkpatch could help advise people to bump the version
> > number, but it's a bit iffy. Matt D. actually uses the special source
> > version modinfo for DKMS - which is different - but it makes me wonder
> > whether dynamically generating a version based on source SHA1 wouldn't
> > be a better idea in most cases than an outdated hard-coded one.
> 
> We've got that already, it's called 'srcversion', and it's a CRC32
> IIRC after some limited parsing to let it ignore whitspace changes and
> comment changes only.  
> 
> $ modinfo dell_rbu | grep version
> version:        3.2
> srcversion:     1D4815D7D6FBEE6612F3C18

Right. And I was referring to the is above (I forgot it's a CRC32 and
not a SHA1). But my point is why not codify some "policy" here with
respect to module versioning, rather than have the latter exist to
workaround the case that module versions aren't bumped manually.

(I'm not arguing to remove srcversion, just asking whether that might be
a better approach in general - perhaps allow a module to print this
version string at init time also, rather than just be in modinfo?)

Jon.



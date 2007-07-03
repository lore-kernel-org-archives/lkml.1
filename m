Return-Path: <linux-kernel-owner+w=401wt.eu-S1759725AbXGCLky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725AbXGCLky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 07:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbXGCLkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 07:40:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:34308 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757530AbXGCLkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 07:40:46 -0400
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
	RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200707030944.18702.oliver@neukum.org>
References: <20070703042916.GA17240@srcf.ucam.org>
	 <200707031608.06348.nigel@nigel.suspend2.net>
	 <1183447184.10386.102.camel@localhost.localdomain>
	 <200707030944.18702.oliver@neukum.org>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 21:40:26 +1000
Message-Id: <1183462826.10386.107.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 09:44 +0200, Oliver Neukum wrote:
> Am Dienstag, 3. Juli 2007 schrieb Benjamin Herrenschmidt:
> > So to summarize, the plan that makes things work with fuse is:
> > 
> >  - For STR, don't do the freezer thing.
> > 
> >  - For STD, don't sys_sync() after you froze
> > 
> > There might be -other- issues, but that should get you through some of
> 
> At the risk of repeating myself. Character device drivers are written
> with the assumption that normal io and suspend/resume do not race
> with each other due to the freezer.
> What do you intend to do about that?

Ugh ... "character devices" ... that's a pretty wide statement...
there's lots of those and very different one from the other...

Any sane device-driver will have to cope with being suspended in a
"live" system. I've demonstrated multiple times in the past why this is
necessary anyway, for things like dynamic power management, among
others.

The whole freezer thing is a hack job to avoid fixing drivers that need
fixing. Unfortunately, I believe in that area, it's simply not
sustainable. Besides, getting drivers to behave properly isn't very hard
in most cases.

Ben.


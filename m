Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbXGCLrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbXGCLrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 07:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758606AbXGCLrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 07:47:07 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:59085 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128AbXGCLrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 07:47:06 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 13:46:56 +0200
User-Agent: KMail/1.9.7
Cc: linux-pm@lists.linux-foundation.org,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707030944.18702.oliver@neukum.org> <1183462826.10386.107.camel@localhost.localdomain>
In-Reply-To: <1183462826.10386.107.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707031346.57613.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Benjamin Herrenschmidt:
> On Tue, 2007-07-03 at 09:44 +0200, Oliver Neukum wrote:
> > Am Dienstag, 3. Juli 2007 schrieb Benjamin Herrenschmidt:
> > > So to summarize, the plan that makes things work with fuse is:
> > > 
> > >  - For STR, don't do the freezer thing.
> > > 
> > >  - For STD, don't sys_sync() after you froze
> > > 
> > > There might be -other- issues, but that should get you through some of
> > 
> > At the risk of repeating myself. Character device drivers are written
> > with the assumption that normal io and suspend/resume do not race
> > with each other due to the freezer.
> > What do you intend to do about that?
> 
> Ugh ... "character devices" ... that's a pretty wide statement...
> there's lots of those and very different one from the other...

That is a good summary of the problem ;-(

> Any sane device-driver will have to cope with being suspended in a
> "live" system. I've demonstrated multiple times in the past why this is
> necessary anyway, for things like dynamic power management, among
> others.

That is an interesting notion. I'd rather see device drivers reporting
their devices idle and requsting to be suspended.
But in any case it doesn't solve the problem.

	Regards
		Oliver


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbYGKUwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbYGKUwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756924AbYGKUwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:52:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41079 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940AbYGKUwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:52:11 -0400
Date: Fri, 11 Jul 2008 22:52:53 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zhang Rui <rui.zhang@intel.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC PATCH 0/4] save and restore ACPI NVS memory
	during hibernation
Message-ID: <20080711205253.GI6843@elf.ucw.cz>
References: <1215051868.5628.32.camel@rzhang-dt.sh.intel.com> <200807092137.18966.rjw@sisk.pl> <20080711185139.GA6843@elf.ucw.cz> <200807112118.35562.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807112118.35562.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-07-11 21:18:34, Rafael J. Wysocki wrote:
> On Friday, 11 of July 2008, Pavel Machek wrote:
> > On Wed 2008-07-09 21:37:18, Rafael J. Wysocki wrote:
> > > On Tuesday, 8 of July 2008, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > > According to the ACPI spec, ACPI NVS memory region is required to
> > > > > be saved/restored by OS during hibernation.
> > > > > 
> > > > > Section 15.3.2 ACPI Spec 3.0b,
> > > > > "OSPM will call the _PTS control method some time before entering
> > > > > a sleeping state, to allow the platform???s AML code to update
> > > > > this memory image before entering the sleeping state.
> > > > > After the system awakes from an S4 state, OSPM will restore this
> > > > > memory area and call the _WAK control method to enable the BIOS
> > > > > to reclaim its memory image."
> > > > > 
> > > > > This patch set add the mechanism to save/restore ACPI NVS memory
> > > > > during hibernation.
> > > > > 
> > > > > Patch 01: call platform_begin before swsusp_shrink_memory.
> > > > > 	So that we can allocate enough pages for ACPI NVS memory
> > > > > 	before shrink the memory.
> > > > 
> > > > Why is it neccessary to allocate memory for a copy? We should be able
> > > > to save ACPI NVS area same way we are saving kernel pages, no?
> > > 
> > > Because we want to restore it from the hibernated kernel (when it gets control
> > > back again).
> > 
> > Why is that important? So we can run some ACPI methods from hibernated
> > kernel before restoring it?
> 
> We're supposed to restore it right prior to executing _WAK, which is after
> we've executed _BFS.  This is a bit theoretical, because no one seems to
> actaully implement _BFS, but well.

Could we just call _BFS from the "loading" kernel, instead? That would
save us that copying code...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

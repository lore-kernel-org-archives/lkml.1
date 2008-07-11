Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYGKSvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYGKSvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbYGKSu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:50:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33278 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbYGKSu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:50:58 -0400
Date: Fri, 11 Jul 2008 20:51:39 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zhang Rui <rui.zhang@intel.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC PATCH 0/4] save and restore ACPI NVS memory
	during hibernation
Message-ID: <20080711185139.GA6843@elf.ucw.cz>
References: <1215051868.5628.32.camel@rzhang-dt.sh.intel.com> <20080708193752.GD8694@ucw.cz> <200807092137.18966.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807092137.18966.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-07-09 21:37:18, Rafael J. Wysocki wrote:
> On Tuesday, 8 of July 2008, Pavel Machek wrote:
> > Hi!
> > 
> > > According to the ACPI spec, ACPI NVS memory region is required to
> > > be saved/restored by OS during hibernation.
> > > 
> > > Section 15.3.2 ACPI Spec 3.0b,
> > > "OSPM will call the _PTS control method some time before entering
> > > a sleeping state, to allow the platform???s AML code to update
> > > this memory image before entering the sleeping state.
> > > After the system awakes from an S4 state, OSPM will restore this
> > > memory area and call the _WAK control method to enable the BIOS
> > > to reclaim its memory image."
> > > 
> > > This patch set add the mechanism to save/restore ACPI NVS memory
> > > during hibernation.
> > > 
> > > Patch 01: call platform_begin before swsusp_shrink_memory.
> > > 	So that we can allocate enough pages for ACPI NVS memory
> > > 	before shrink the memory.
> > 
> > Why is it neccessary to allocate memory for a copy? We should be able
> > to save ACPI NVS area same way we are saving kernel pages, no?
> 
> Because we want to restore it from the hibernated kernel (when it gets control
> back again).

Why is that important? So we can run some ACPI methods from hibernated
kernel before restoring it?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

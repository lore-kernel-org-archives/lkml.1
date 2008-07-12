Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbYGLAiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbYGLAiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 20:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbYGLAii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 20:38:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32975 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbYGLAih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 20:38:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [linux-pm] [RFC PATCH 0/4] save and restore ACPI NVS memory during hibernation
Date: Sat, 12 Jul 2008 02:40:20 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Pavel Machek" <pavel@suse.cz>, "Zhang Rui" <rui.zhang@intel.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1215051868.5628.32.camel@rzhang-dt.sh.intel.com> <200807112259.56263.rjw@sisk.pl> <86802c440807111456k5d46a46co18bee343541fed8c@mail.gmail.com>
In-Reply-To: <86802c440807111456k5d46a46co18bee343541fed8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807120240.21477.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 of July 2008, Yinghai Lu wrote:
> On Fri, Jul 11, 2008 at 1:59 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, 11 of July 2008, Pavel Machek wrote:
> >> On Fri 2008-07-11 21:18:34, Rafael J. Wysocki wrote:
> >> > On Friday, 11 of July 2008, Pavel Machek wrote:
> >> > > On Wed 2008-07-09 21:37:18, Rafael J. Wysocki wrote:
> >> > > > On Tuesday, 8 of July 2008, Pavel Machek wrote:
> >> > > > > Hi!
> >> > > > >
> >> > > > > > According to the ACPI spec, ACPI NVS memory region is required to
> >> > > > > > be saved/restored by OS during hibernation.
> >> > > > > >
> >> > > > > > Section 15.3.2 ACPI Spec 3.0b,
> >> > > > > > "OSPM will call the _PTS control method some time before entering
> >> > > > > > a sleeping state, to allow the platform???s AML code to update
> >> > > > > > this memory image before entering the sleeping state.
> >> > > > > > After the system awakes from an S4 state, OSPM will restore this
> >> > > > > > memory area and call the _WAK control method to enable the BIOS
> >> > > > > > to reclaim its memory image."
> >> > > > > >
> >> > > > > > This patch set add the mechanism to save/restore ACPI NVS memory
> >> > > > > > during hibernation.
> >> > > > > >
> >> > > > > > Patch 01: call platform_begin before swsusp_shrink_memory.
> >> > > > > >     So that we can allocate enough pages for ACPI NVS memory
> >> > > > > >     before shrink the memory.
> >> > > > >
> >> > > > > Why is it neccessary to allocate memory for a copy? We should be able
> >> > > > > to save ACPI NVS area same way we are saving kernel pages, no?
> >> > > >
> >> > > > Because we want to restore it from the hibernated kernel (when it gets control
> >> > > > back again).
> >> > >
> >> > > Why is that important? So we can run some ACPI methods from hibernated
> >> > > kernel before restoring it?
> >> >
> >> > We're supposed to restore it right prior to executing _WAK, which is after
> >> > we've executed _BFS.  This is a bit theoretical, because no one seems to
> >> > actaully implement _BFS, but well.
> >>
> >> Could we just call _BFS from the "loading" kernel, instead? That would
> >> save us that copying code...
> >
> > I'd prefer not to, because that would require the boot kernel to support ACPI,
> > which need not (and in fact should not IMO) be the case at present.
> >
> > Anyway, we'd have to either copy the NVS data into memory which is mapped and
> > can be saved, or to map the NVS area in order to save/restore it, which I
> > wouldn't like to do.
> 
> io_remap doesn't work at that time?

Yes, it does, but to use it, we would have to add extra information to the
image header describing the location of the NVS data within the image.
I prefer the Zhang Rui's approach to this.

Thanks,
Rafael

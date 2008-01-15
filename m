Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYAOHvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYAOHvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 02:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYAOHvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 02:51:39 -0500
Received: from mail1.perex.cz ([212.20.107.53]:54024 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbYAOHvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 02:51:38 -0500
Date: Tue, 15 Jan 2008 08:51:35 +0100 (CET)
From: Jaroslav Kysela <perex@perex.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Rene Herman <rene.herman@keyaccess.nl>, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus@drzeus.cx>,
       Pavel Machek <pavel@suse.cz>, Ondrej Zary <linux@rainbow-software.org>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, linux-pm@lists.linux-foundation.org
Subject: Re: -mm: pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
 breaks resuming isapnp cards
In-Reply-To: <200801141526.57744.bjorn.helgaas@hp.com>
Message-ID: <Pine.LNX.4.61.0801150842480.7446@tm8103.perex-int.cz>
References: <200801092343.48726.linux@rainbow-software.org>
 <200801122250.44220.bjorn.helgaas@hp.com> <4789AC0F.9030007@keyaccess.nl>
 <200801141526.57744.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008, Bjorn Helgaas wrote:

> On Saturday 12 January 2008 11:13:35 pm Rene Herman wrote:
> > ... And, now that I have your attention, while it's 
> > not important to the issue anymore with the tests removed as the submitted 
> > patch did, do you have an opinion on (include/linux/pnp.h):
> > 
> > /* pnp driver flags */
> > #define PNP_DRIVER_RES_DO_NOT_CHANGE    0x0001  /* do not change the state 
> > of the device */
> > #define PNP_DRIVER_RES_DISABLE          0x0003  /* ensure the device is 
> > disabled */
> > 
> > I find DISABLE including DO_NOT_CHANGE rather unexpected...
> 
> I don't know the history of those flags, but I wish they didn't exist.

Ok, something to explain. These flags exists to allow drivers to 
manually configure (override) PnP resources at init time - we know - for 
example in ALSA - that some combinations simply does not work for all 
soundcards.

The DISABLE flags simply tells core PnP layer - driver will handle 
resource allocation itself, don't do anything, just disable hw physically 
and do not change (allocate) any resources. Value 0x03 is valid in this 
semantics.

Unfortunately, suspend / resume complicates things a bit, but PnP core can 
handle DO_NOT_CHANGE flag. But it will just mean - _preserve_ resource 
allocation from last suspend state for this device and enable hw 
physically before calling resume() callback.

					Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.


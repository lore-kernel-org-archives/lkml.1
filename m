Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYANWab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYANWab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbYANW0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:26:44 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:39493 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747AbYANW0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:26:42 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: -mm: pnp-do-not-stop-start-devices-in-suspend-resume-path.patch breaks resuming isapnp cards
Date: Mon, 14 Jan 2008 15:26:56 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pierre Ossman <drzeus@drzeus.cx>, Pavel Machek <pavel@suse.cz>,
       Ondrej Zary <linux@rainbow-software.org>,
       Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, linux-pm@lists.linux-foundation.org
References: <200801092343.48726.linux@rainbow-software.org> <200801122250.44220.bjorn.helgaas@hp.com> <4789AC0F.9030007@keyaccess.nl>
In-Reply-To: <4789AC0F.9030007@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801141526.57744.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 January 2008 11:13:35 pm Rene Herman wrote:
> ... And, now that I have your attention, while it's 
> not important to the issue anymore with the tests removed as the submitted 
> patch did, do you have an opinion on (include/linux/pnp.h):
> 
> /* pnp driver flags */
> #define PNP_DRIVER_RES_DO_NOT_CHANGE    0x0001  /* do not change the state 
> of the device */
> #define PNP_DRIVER_RES_DISABLE          0x0003  /* ensure the device is 
> disabled */
> 
> I find DISABLE including DO_NOT_CHANGE rather unexpected...

I don't know the history of those flags, but I wish they didn't exist.
They really look like warts in the PNP core code.  They're used so
infrequently and without obvious rationale, that it seems like it'd
be better if there were a way to deal with them inside the driver.

But to answer your question, I don't know enough to have an opinion
on whether DISABLE should include DO_NOT_CHANGE.

> By the way, I also still have this next one outstanding for you... :-/
> 
> http://lkml.org/lkml/2008/1/9/168

This had to do with the excessive warnings about exceeding the maximum
number of resources for a PNP device.  This should be resolved by Len's
patch here:

  http://bugzilla.kernel.org/show_bug.cgi?id=9535#c10

We all agree this is a stop-gap, and for 2.6.25, we need the real
solution of making PNP resources fully dynamic.

Bjorn

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYAMFxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYAMFxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 00:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYAMFxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 00:53:31 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:29846 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYAMFxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 00:53:31 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: -mm: pnp-do-not-stop-start-devices-in-suspend-resume-path.patch breaks resuming isapnp cards
Date: Sat, 12 Jan 2008 22:50:42 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pierre Ossman <drzeus@drzeus.cx>, Pavel Machek <pavel@suse.cz>,
       Ondrej Zary <linux@rainbow-software.org>,
       Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, linux-pm@lists.linux-foundation.org
References: <200801092343.48726.linux@rainbow-software.org> <200801122008.10313.rjw@sisk.pl> <47891E21.8060209@keyaccess.nl>
In-Reply-To: <47891E21.8060209@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801122250.44220.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 January 2008 1:08:01 pm Rene Herman wrote:
> pnp-do-not-stop-start-devices-in-suspend-resume-path.patch in current -mm
> breaks resuming isapnp cards from hibernation. They need the pnp_start_dev
> to enable the device again after hibernation.
>
> They don't really need the pnp_stop_dev() which the above mentioned patch
> also removes but with the pnp_start_dev() restored it seems pnp_stop_dev()
> should also stay. Bjorn Helgaas should decide  -- currently the patch as
> you have it breaks drivers though. Could you drop it?

Yes, please drop pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
for now.

When the PNP core requested resources for active devices, the
pnp_stop_dev() in the suspend path released the PNP core resources,
leaving the underlying driver resources orphaned.  But the patch
that made the PNP core request those resource is also gone, so
we can leave the start/stop alone.

> On 12-01-08 20:08, Rafael J. Wysocki wrote:
> > On Saturday, 12 of January 2008, Rene Herman wrote:
> >> It seems all PnP drivers would need to stick a pnp_start_dev in their
> >> resume method
> >
> > Yes.
> >
> >> then which means it really belongs in core.
> >
> > Yes, if practical.
> >
> >> One important point where PnP and PCI differ is that PnP allows to
> >> change the resources on a protocol level and I don't see how it could
> >> ever not be necessary to restore the state a user may have set if power
> >> has been removed. Hibernate is just that, isn't it?

That's a good point, thanks for pointing that out.

Bjorn

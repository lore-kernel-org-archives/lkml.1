Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbYALQrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbYALQrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 11:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYALQrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 11:47:25 -0500
Received: from ns.gsystems.sk ([62.176.172.50]:41599 "EHLO www.gsystems.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbYALQrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 11:47:24 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [alsa-devel] PNP_DRIVER_RES_DISABLE breaks swsusp at least with snd_cs4236
Date: Sat, 12 Jan 2008 17:46:53 +0100
User-Agent: KMail/1.9.7
Cc: Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>, linux-pm@lists.linux-foundation.org
References: <200801092343.48726.linux@rainbow-software.org> <4788C323.6090206@keyaccess.nl> <20080112162150.1ec9cad0@poseidon.drzeus.cx>
In-Reply-To: <20080112162150.1ec9cad0@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801121746.57177.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 January 2008 16:21:50 Pierre Ossman wrote:
> On Sat, 12 Jan 2008 14:39:47 +0100
>
> Rene Herman <rene.herman@keyaccess.nl> wrote:
> > On 12-01-08 12:12, Pierre Ossman wrote:
> > > I'm a bit confused here. Bjorn Helgaas wanted to remove the
> > > pnp_start/stop_dev() calls completely, and you want them called all the
> > > time. :)
> >
> > Wanted where? Haven't seen a coment from Bjorn? But -- while removing
> > them both looks (as) sensible from a mirror-image viewpoint, this
> > wouldn't fix the problem.
>
> Ah, sorry. It was a different thread. Look for a mail with the subject
> "PNP: do not stop/start devices in suspend/resume path" in the LKML och
> linux-pm archives.
>
> > But we certainly need the pnp_start_dev() in the current flow of things.
> > It not being called is the problem this fixes...
>
> I think the previous suggestion was that the drivers should call this, not
> the core, so that it behaved more like other parts of the kernel (e.g.
> PCI).

I don't think that drivers should call pnp_start_dev() on resume. All drivers 
would need to call it as all PnP cards are disabled after boot. No driver 
does that currently.

3c509 driver doesn't seem to register as pnp_card_driver so that's probably 
why it's not enable after resume. I guess that more ISA PnP drivers have this 
problem. I have some other PnP network and sound cards so I'll test them.

-- 
Ondrej Zary

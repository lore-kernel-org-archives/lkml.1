Return-Path: <linux-kernel-owner+w=401wt.eu-S1760597AbYALTF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597AbYALTF5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 14:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbYALTFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 14:05:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34229 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458AbYALTFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 14:05:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [alsa-devel] PNP_DRIVER_RES_DISABLE breaks swsusp at least with snd_cs4236
Date: Sat, 12 Jan 2008 20:08:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pierre Ossman <drzeus@drzeus.cx>, Pavel Machek <pavel@suse.cz>,
       Ondrej Zary <linux@rainbow-software.org>,
       Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>, linux-pm@lists.linux-foundation.org
References: <200801092343.48726.linux@rainbow-software.org> <20080112162150.1ec9cad0@poseidon.drzeus.cx> <4788F226.7040101@keyaccess.nl>
In-Reply-To: <4788F226.7040101@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801122008.10313.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 of January 2008, Rene Herman wrote:
> On 12-01-08 16:21, Pierre Ossman wrote:
> 
> > Ah, sorry. It was a different thread. Look for a mail with the subject 
> > "PNP: do not stop/start devices in suspend/resume path" in the LKML och 
> > linux-pm archives.
> 
> Right, and I see that the removal of start/stop is already in -mm. That's 
> not going to work. Something (such as removing power) disabled Ondrej's 
> CS4236 and the pnp_start_dev() is needed to re-enable it upon resume.
> 
> >> But we certainly need the pnp_start_dev() in the current flow of
> >> things. It not being called is the problem this fixes...
> > 
> > I think the previous suggestion was that the drivers should call this,
> > not the core, so that it behaved more like other parts of the kernel
> > (e.g. PCI).
> 
> It seems all PnP drivers would need to stick a pnp_start_dev in their resume 
> method

Yes.

> then which means it really belongs in core.

Yes, if practical.

> One important point where PnP and PCI differ is that PnP allows to change the
> resources on a protocol level and I don't see how it could ever not be
> necessary to restore the state a user may have set if power has been
> removed. Hibernate is just that, isn't it?

Basically, yes, it is.

Thanks,
Rafael

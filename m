Return-Path: <linux-kernel-owner+w=401wt.eu-S1759072AbYALRDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072AbYALRDl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 12:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbYALRDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 12:03:32 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:33289 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbYALRDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 12:03:32 -0500
Message-ID: <4788F226.7040101@keyaccess.nl>
Date: Sat, 12 Jan 2008 18:00:22 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ondrej Zary <linux@rainbow-software.org>,
       Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>, linux-pm@lists.linux-foundation.org
Subject: Re: [alsa-devel] PNP_DRIVER_RES_DISABLE breaks swsusp at least with
 snd_cs4236
References: <200801092343.48726.linux@rainbow-software.org>	<20080111080141.75aaad5f@poseidon.drzeus.cx>	<47877B83.5040604@keyaccess.nl>	<200801111940.22023.linux@rainbow-software.org>	<4788168F.8070403@keyaccess.nl>	<20080112121256.0f2e96ad@poseidon.drzeus.cx>	<4788C323.6090206@keyaccess.nl> <20080112162150.1ec9cad0@poseidon.drzeus.cx>
In-Reply-To: <20080112162150.1ec9cad0@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-01-08 16:21, Pierre Ossman wrote:

> Ah, sorry. It was a different thread. Look for a mail with the subject 
> "PNP: do not stop/start devices in suspend/resume path" in the LKML och 
> linux-pm archives.

Right, and I see that the removal of start/stop is already in -mm. That's 
not going to work. Something (such as removing power) disabled Ondrej's 
CS4236 and the pnp_start_dev() is needed to re-enable it upon resume.

>> But we certainly need the pnp_start_dev() in the current flow of
>> things. It not being called is the problem this fixes...
> 
> I think the previous suggestion was that the drivers should call this,
> not the core, so that it behaved more like other parts of the kernel
> (e.g. PCI).

It seems all PnP drivers would need to stick a pnp_start_dev in their resume 
method then which means it really belongs in core. One important point where 
PnP and PCI differ is that PnP allows to change the resources on a protocol 
level and I don't see how it could ever not be necessary to restore the 
state a user may have set if power has been removed. Hibernate is just that, 
isn't it?

Rene.

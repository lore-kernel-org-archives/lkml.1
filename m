Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbYKNCjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbYKNCjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYKNCjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:39:04 -0500
Received: from mail.queued.net ([207.210.101.209]:3231 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbYKNCjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:39:02 -0500
Date: Thu, 13 Nov 2008 21:38:52 -0500
From: Andres Salomon <dilinger@queued.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@suse.cz>,
       Jeremy Katz <katzj@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jordan Crouse <jordan.crouse@amd.com>, linux-kernel@vger.kernel.org,
       dsaxena@laptop.org
Subject: Re: [PATCH] ALSA: cs5535audio: only build OLPC support if	MGEODE_LX
 is defined
Message-ID: <20081113213852.16561ed2@ephemeral>
In-Reply-To: <s5hzlk3kxuf.wl%tiwai@suse.de>
References: <20081109201710.4c490f04@debxo>
	<1226498050.12791.45.camel@aglarond.local>
	<s5hbpwlj9w1.wl%tiwai@suse.de>
	<1226547898.13077.83.camel@aglarond.local>
	<s5h63msru7z.wl%tiwai@suse.de>
	<20081113153714.GA1520@ucw.cz>
	<s5h3ahvhb9w.wl%tiwai@suse.de>
	<20081113111428.59aa36cb@ephemeral>
	<20081113163802.GA1734@ucw.cz>
	<20081113120147.2ecde3c8@ephemeral>
	<20081113190339.GE17851@elte.hu>
	<s5hzlk3kxuf.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 00:30:48 +0100
Takashi Iwai <tiwai@suse.de> wrote:

> At Thu, 13 Nov 2008 20:03:39 +0100,
> Ingo Molnar wrote:
> > 
> > 
> > * Andres Salomon <dilinger@queued.net> wrote:
> > 
> > > On Thu, 13 Nov 2008 17:38:02 +0100
> > > Pavel Machek <pavel@suse.cz> wrote:
> > > 
> > > > On Thu 2008-11-13 11:14:28, Andres Salomon wrote:
> > > > > On Thu, 13 Nov 2008 16:54:19 +0100
> > > > > Takashi Iwai <tiwai@suse.de> wrote:
> > > > > 
> > > > > > At Thu, 13 Nov 2008 16:37:14 +0100,
> > > > > > Pavel Machek wrote:
> > > > > [...]
> > > > > > > 
> > > > > > > > IMO, the basic problem is rather that the platform and
> > > > > > > > the CPU selection is mixed up.  The geode GPIO stuff
> > > > > > > > shouldn't belong to CPU selection.
> > > > > > > 
> > > > > > > ACK... and suggested patch makes it worse.
> > > > > > > 
> > > > > > > There should be option 'support OLPC' somewhere, and that
> > > > > > > should enable the gpio bits. Alsa driver should depend on
> > > > > > > that one.
> > > > > > 
> > > > > > Any better fix patch is welcome, of course :)
> > > > > > This would make save a lot time than writing mails...
> > > > 
> > > > > 
> > > > > Okay, how about something like the following?
> > > > 
> > > > It is wrong. It is valid & useful to compile kernel for i386 and
> > > > expect all the features on OLPC (with small performance hit).
> > > 
> > > No one's debating that.  That requires additional work that will 
> > > take longer, however.
> > 
> > i've zapped this patch meanwhile:
> > 
> >  1355c96: x86/olpc: make CONFIG_OLPC dependent on CONFIG_MGEODE_LX
> > 
> > because it cripples the ability to run distribution kernels on the 
> > OLPC.
> 
> OK, I reverted also all relevant changes for cs5535audio driver now.
> The patches are saved in topic/cs5535audio branch, though.
> 
> Let's fix OLPC-geode coupling first.
> 


Hm, I'd really rather prefer this to be upstream.  The patch I sent adds
no regressions, allows the driver to happily coexist with existing
stuff, and *does* add support if you configure OLPC with MGEODE_LX
(generic kernels don't get the additional benefits, but those configured
specifically for OLPC do).


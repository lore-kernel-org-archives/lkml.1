Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbXDZOoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbXDZOoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031222AbXDZOoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:44:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50111 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbXDZOoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:44:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Thu, 26 Apr 2007 16:48:23 +0200
User-Agent: KMail/1.9.5
Cc: "Pavel Machek" <pavel@ucw.cz>,
       "Dumitru Ciobarcianu" <Dumitru.Ciobarcianu@ines.ro>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Christian Hesse" <mail@earthworm.de>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>, linux-kernel@vger.kernel.org,
       "Con Kolivas" <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@infradead.org>
References: <20070418220228.GA14536@elte.hu> <20070425081051.GA7221@ucw.cz> <84144f020704260412t56b6db08h9d0d2961158e33fd@mail.gmail.com>
In-Reply-To: <84144f020704260412t56b6db08h9d0d2961158e33fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261648.25189.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 26 April 2007 13:12, Pekka Enberg wrote:
> On 4/25/07, Pavel Machek <pavel@ucw.cz> wrote:
> > > Please stop using FUD.
> > > Graphical progress it's not in the kernel, even with suspend2.
> >
> > It was ascii-art, but still 'graphical', last time I checked.
> 
> Suspend2 talks to an userspace client via netlink. While I find the
> name of the message ("redraw UI") rather appaling, there's nothing
> wrong in principle that userspace starts the suspend process and the
> kernel keeps feeding back progress information ("I froze all processes
> now") so it can display a graphical progress bar.
> 
> The real question here is what to do with compression and encryption.
> However, if you settle for one compression algorithm (such as LZF in
> the case of suspend2) and use the _existing_ in-kernel crypto API for
> encryption, suddenly the benefits of userspace suspend are not clear.
> 
> As you and Rafael seem to be mostly interested in uswsusp, why don't
> we replace the old in-kernel implementation with suspend2?

It has a lot of common code with uswsusp.  Practically, the saving of the image
is the only part of it that could be removed, but this is simple and _really_
helps with debugging.

In principle, we could add suspend2 as an alternative (in analogy with the I/O
schedulers, for example), but I think for this purpose it should be reviewed
properly.

There also is a real problem with how it uses the LRU pages.  It _seems_ to
work, but at least to me it seems to be potentially dangerous.

Greetings,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbXJXPZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbXJXPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXJXPZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:25:16 -0400
Received: from outbound-mail-80.bluehost.com ([69.89.22.29]:34046 "HELO
	outbound-mail-80.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752211AbXJXPZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:25:14 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 11:25:13 EDT
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] full suspend/resume support for i915 DRM driver
Date: Wed, 24 Oct 2007 08:18:30 -0700
User-Agent: KMail/1.9.7
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200710181401.50470.jbarnes@virtuousgeek.org> <20071024133514.GB4898@ucw.cz>
In-Reply-To: <20071024133514.GB4898@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710240818.31128.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 24, 2007 6:35:14 am Pavel Machek wrote:
> Hi!
>
> > We seem to see a lot of bug reports along the lines of, "my machine
> > resumes but I can't see X" or, "I can see X but only with a bright
> > flashlight", etc.  These sorts of problems are due to the fact that
> > the X server isn't designed to do full state save/restore, and none
> > of the available kernel drivers do it on its behalf.
> >
> > Since intelfb and the rest of the Intel drivers are fairly incompatible,
> > this patch makes the DRM bind to the PCI device so it can register real
> > suspend/resume handlers.  Those handlers take care of saving and
> > restoring enough state for X to come back reliably on at least one of my
> > problematic test machines, but text mode still has trouble (still
> > debugging VGA state save/restore, including trying to save/restore
> > actual VRAM contents for possible hibernate support).
> >
> > How does this approach look?  Is a new DRM driver flag a good thing for
> > similar situations with other drivers?  Thoughts?
>
> Looks okay to me... from very quick look.
>
> > +	if (!i915_pipe_enabled(dev, pipe))
> > +		return;
> > +
> > +	if (pipe == PIPE_A)
> > +		array = dev_priv->savePaletteA;
>
> coding style, we probably want save_palette_A.

Yeah, I tried not to pull over uglies from the X code but I guess I forgot 
this bit.  I should also update the copyright.

> > +	unsigned long reg = pipe == PIPE_A ? PALETTE_A : PALETTE_B;
>
> Uff. Mixing = and == and ? in one expression is evil.

I could put parens around it if you think that would help, or just move it to 
a new line...

> I think I seen some #if 0 code.... just remove that.

Oh I left some in there?  Yeah I'll remove it.

Thanks,
Jesse

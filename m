Return-Path: <linux-kernel-owner+w=401wt.eu-S1759221AbXJXNfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221AbXJXNfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbXJXNf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:35:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4634 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755829AbXJXNfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:35:24 -0400
Date: Wed, 24 Oct 2007 13:35:14 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC] full suspend/resume support for i915 DRM driver
Message-ID: <20071024133514.GB4898@ucw.cz>
References: <200710181401.50470.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710181401.50470.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> We seem to see a lot of bug reports along the lines of, "my machine
> resumes but I can't see X" or, "I can see X but only with a bright
> flashlight", etc.  These sorts of problems are due to the fact that
> the X server isn't designed to do full state save/restore, and none
> of the available kernel drivers do it on its behalf.
> 
> Since intelfb and the rest of the Intel drivers are fairly incompatible,
> this patch makes the DRM bind to the PCI device so it can register real
> suspend/resume handlers.  Those handlers take care of saving and
> restoring enough state for X to come back reliably on at least one of my
> problematic test machines, but text mode still has trouble (still
> debugging VGA state save/restore, including trying to save/restore
> actual VRAM contents for possible hibernate support).
> 
> How does this approach look?  Is a new DRM driver flag a good thing for
> similar situations with other drivers?  Thoughts?

Looks okay to me... from very quick look.

> +	if (!i915_pipe_enabled(dev, pipe))
> +		return;
> +
> +	if (pipe == PIPE_A)
> +		array = dev_priv->savePaletteA;


coding style, we probably want save_palette_A.

> +	unsigned long reg = pipe == PIPE_A ? PALETTE_A : PALETTE_B;

Uff. Mixing = and == and ? in one expression is evil.

I think I seen some #if 0 code.... just remove that.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbZBYUm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbZBYUm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbZBYUmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:42:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:53773 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbZBYUmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:42:17 -0500
Subject: Re: ATI Radeon DIRECTCOLOR -> TRUECOLOR patch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: jon@nerdgrounds.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090225.035712.103590506.davem@davemloft.net>
References: <49A52A73.2000406@nerdgrounds.com>
	 <20090225.035712.103590506.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 07:42:04 +1100
Message-Id: <1235594524.8805.326.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-25 at 03:57 -0800, David Miller wrote:
> From: Jonathan Campbell <jon@nerdgrounds.com>
> Date: Wed, 25 Feb 2009 03:24:35 -0800
> 
> [ Ben H. is the Radeon driver maintainer, as listed in
>   linux/MAINTAINERS, you might want to CC: him ]
> 
> > I don't know about you but when I ask the framebuffer to set up
> > 16-bit or 32-bit RGB modes I expect a video mode to be set up with
> > R, G, and B mapped linearly so that I can display images properly,
> > not some odd "directcolor" mode that seems to serve no other purpose
> > than to avoid a few shifts converting the fbcon palette to an RGB
> > triplet.
> 
> It might be using DIRECTCOLOR for compatibility with openfirmware,
> BOOTX, or similar on PowerPC.

Hrm, the kernel fb layer does seem to do strange things with the palette
for >8bpp stuff indeed. I'm not entirely sure why.

The problem if you switch to truecolor is that you remove the ability to
set the gamma ramp completely which some apps use.

Normally, I'd say it's the responsibility of your application, when it's
displaying pictures, to set an appropriate cmap. If you don't like the
one set by fbcon for displaying text, just set another one. Ie. You
aren't -supposed- to mix graphics and fbcon text from an application...
if you're going to blast to the fb, you should switch to KD_GRAPHICS (ie
take ownership of the VT) and set a linear ramp yourself.

Cheers,
Ben.



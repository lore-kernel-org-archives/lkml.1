Return-Path: <linux-kernel-owner+w=401wt.eu-S1761506AbXEVAUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506AbXEVAUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbXEVAUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:20:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:51759 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141AbXEVAUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:20:09 -0400
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <9e4733910705211042o8926e4cy2225c2dbcbf3ff2@mail.gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com>
	 <9e4733910705210901v5996cacas640f211404c519c6@mail.gmail.com>
	 <200705210914.22663.jbarnes@virtuousgeek.org>
	 <200705210934.58559.jbarnes@virtuousgeek.org>
	 <9e4733910705211005k761c976o1a6b270d87b49589@mail.gmail.com>
	 <21d7e9970705211014j6eb59326u85f7347a3000f3d3@mail.gmail.com>
	 <9e4733910705211042o8926e4cy2225c2dbcbf3ff2@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 22 May 2007 10:20:01 +1000
Message-Id: <1179793201.32247.777.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 13:42 -0400, Jon Smirl wrote:
> 
> When I went through the design process for all this I came to the same
> conclusion about needing a user space console process.
> 
> User space console does impact on all of this because it implies that
> the current console should be be defeatured down until it becomes only
> a system recovery console and not a console for everyday use.

I do agree (heh, for once) with that in the sense that in the long run,
we should strip the kernel console down to the bare minimum to boot,
display oopses, etc... and have all the fancy stuff, unicode, VT, and
more in a userspace console process.

However, I'm a little bit worried that we'll end up with 10 competing
incompatible and inconsistent userspace console projects and -that- will
be horrible.

But it's something separate from what Dave and Jesse are trying to
address. Let's first gets the fundation right and -then- we can do all
sort of crazy things. Or maybe you can start working on a user console
project in parallel using the new APIs that Jesse and Dave are
providing ? :-)

> For example, one part of the defeaturing would be to remove the
> drawing acceleration code in the existing fbdev console drivers and to
> rework it to support accelerated drawing from the user space console
> implementation. You want the system recovery console mode to be as
> simple as possible so that it is always guaranteed to work. User space
> console is also what leads to the idea of compiling VT out of the
> kernel.

I do agree on that in the long run, but again, let's look into this
-after- we have solved the more immediate issues. We can probably kill
most of fbdev, fbcon and current VT once we have a solid userland based
replacement that isn't completely bloated (maybe with a "slim" version
that does only VGA and non-utf8 for server type apps).

> Once you decide that a user space console is needed then the per CRTC
> device node becomes more obvious since different people can be logged
> onto the different consoles.

That's irrelevant. Implementation detail.

> All of the points in the list are interrelated and the architecture
> needs to address everything as a unified whole.

And that's bullshit :-)

Ben.



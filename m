Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbZIYHgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbZIYHgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbZIYHgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:36:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55878 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbZIYHgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:36:37 -0400
Date: Fri, 25 Sep 2009 08:36:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stanislav Brabec <utx@penguin.cz>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial-core: resume serial hardware with
	no_console_suspend
Message-ID: <20090925073617.GA5856@n2100.arm.linux.org.uk>
References: <1253021938.6597.16.camel@hammer.suse.cz> <20090924170503.37cbe4ed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924170503.37cbe4ed.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 05:05:03PM -0700, Andrew Morton wrote:
> On Tue, 15 Sep 2009 15:38:58 +0200
> Stanislav Brabec <utx@penguin.cz> wrote:
> 
> > Hardware may need re-initialization to get serial port working after
> > resume. It does not happen with no_console_suspend. Attached patch
> > attempts to fix it.
> > 
> > The patch attempts to keep hardware running before suspend and run
> > hardware re-initialization after resume. Maybe simpler approach is
> > possible.
> 
> The patch doesn't apply any more and seems like a rather hacky thing to do.
> 
> It appears that you have specific serial hardware which doesn't resume
> correctly?  If so, that's a bug, so how about we start with a bug
> report/description?

It's something that I did point out when the no_console_suspend patch
appeared, but I was overruled/ignored.

The problem is that on ARM hardware, there is no BIOS to re-initialize
hardware.  The kernel has to do restore the entire system hardware
state upon resume.  Unfortunately, no_console_suspend not only prevents
the console from being suspended but _also_ resumed.

The result of that is the console UART is left in a totally uninitialized
state.

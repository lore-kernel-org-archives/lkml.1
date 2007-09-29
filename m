Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbXI2S1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbXI2S1v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 14:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXI2S1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 14:27:43 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46081 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbXI2S1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 14:27:42 -0400
Date: Sat, 29 Sep 2007 20:29:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, Adrian Bunk <bunk@kernel.org>,
       roel <12o3l@tiscali.nl>
Subject: Re: [PATCH 1/3] CodingStyle updates
Message-ID: <20070929182909.GA19943@uranus.ravnborg.org>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu> <11910151223447-git-send-email-ezk@cs.sunysb.edu> <20070929110129.307cbd9f.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070929110129.307cbd9f.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 11:01:29AM -0700, Randy Dunlap wrote:
> On Fri, 28 Sep 2007 17:32:00 -0400 Erez Zadok wrote:
> 
> > 1. Updates chapter 13 (printing kernel messages) to expand on the use of
> >    pr_debug()/pr_info(), what to avoid, and how to hook your debug code with
> >    kernel.h.
> > 
> > Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> > ---
> >  Documentation/CodingStyle |   88 +++++++++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 86 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> > index 7f1730f..00b29e4 100644
> > --- a/Documentation/CodingStyle
> > +++ b/Documentation/CodingStyle
> > @@ -643,8 +643,26 @@ Printing numbers in parentheses (%d) adds no value and should be avoided.
> >  There are a number of driver model diagnostic macros in <linux/device.h>
> >  which you should use to make sure messages are matched to the right device
> >  and driver, and are tagged with the right level:  dev_err(), dev_warn(),
> > -dev_info(), and so forth.  For messages that aren't associated with a
> > -particular device, <linux/kernel.h> defines pr_debug() and pr_info().
> > +dev_info(), and so forth.
> > +
> > +A number of people often like to define their own debugging printf's,
> > +wrapping printk's in #ifdef's that get turned on only when subsystem
> > +debugging is compiled in (e.g., dprintk, Dprintk, DPRINTK, etc.).  Please
> > +don't reinvent the wheel but use existing mechanisms.  For messages that
> > +aren't associated with a particular device, <linux/kernel.h> defines
> > +pr_debug() and pr_info(); the latter two translate to printk(KERN_DEBUG) and
> > +printk(KERN_INFO), respectively.  However, to get pr_debug() to actually
> > +emit the message, you'll need to turn on DEBUG in your code, which can be
> > +done as follows in your subsystem Makefile:
> > +
> > +ifeq ($(CONFIG_WHATEVER_DEBUG),y)
> > +EXTRA_CFLAGS += -DDEBUG
> > +endif
The abvoe hurst my eyes each time I see it.
Lately I have considered extending the kbuild syntax a bit.

Introducing
ccflags-y
asflags-y

[with same functionality as the EXTRA_CFLAGS, EXTRA_AFLAGS]
would allow us to do:

ccflags-$(CONFIG_WHATEVER_DEBUG) := -DDEBUG

Much nicer IMHO.

	Sam

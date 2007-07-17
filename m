Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbXGQSQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbXGQSQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763406AbXGQSP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:15:59 -0400
Received: from kukmak.uni-mb.si ([164.8.100.3]:48336 "EHLO kukmak.uni-mb.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758385AbXGQSP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:15:57 -0400
X-Greylist: delayed 1625 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2007 14:15:56 EDT
Date: Tue, 17 Jul 2007 19:48:40 +0200
From: Domen Puncer <domen.puncer@telargo.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce __init_exit function annotation
Message-ID: <20070717174840.GN2400@nd47.coderock.org>
References: <20070717080248.GK4375@moe.telargo.com> <20070717130230.GB24780@uranus.ravnborg.org> <s5htzs3ulpf.wl%tiwai@suse.de> <20070717151432.GA25939@uranus.ravnborg.org> <s5hodibukle.wl%tiwai@suse.de> <20070717153236.GB25939@uranus.ravnborg.org> <s5hir8jujhc.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hir8jujhc.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/07 17:40 +0200, Takashi Iwai wrote:
> At Tue, 17 Jul 2007 17:32:36 +0200,
> Sam Ravnborg wrote:
> > 
> > On Tue, Jul 17, 2007 at 05:16:13PM +0200, Takashi Iwai wrote:
> > > At Tue, 17 Jul 2007 17:14:32 +0200,
> > > Sam Ravnborg wrote:
> > > > 
> > > > On Tue, Jul 17, 2007 at 04:52:12PM +0200, Takashi Iwai wrote:
> > > > > At Tue, 17 Jul 2007 15:02:30 +0200,
> > > > > Sam Ravnborg wrote:
> > > > > > 
> > > > > > On Tue, Jul 17, 2007 at 10:02:48AM +0200, Domen Puncer wrote:
> > > > > > > Introduce __init_exit, which is useful ie. for drivers that call
> > > > > > > cleanup functions when they fail in __init functions.
> > > > > > 
> > > > > > This is wrong.
> > > > > > On arm (just one example of several) the __exit section are discarded
> > > > > > at buildtime so any reference from __init to __exit will cause the
> > > > > > linker to error out.
> > > > > 
> > > > > Hmm, from what I see, it adds __init to the function.  There is no
> > > > > reference to __exit.
> > > > 
> > > > The cleanup functions are marked __exit in the referenced case.
> > > 
> > > My understanding is that it's the very purpose of this patch --
> > > change the mark from __exit to __init_exit for such clean-up
> > > functions.
> > 
> > And that is wrong.
> 
> You misunderstood.  What I meant is the case like this:
> 
> static void __init_exit cleanup()
> {
> 	...
> }
> 
> static void __init foo_init()
> {
> 	if (error)
> 		cleanup();
> }
> 
> static void __exit foo_exit()
> {
> 	cleanup();
> }

Uh, yes, this, or just __init_exit foo_exit() as in Sam's example.
It seemed obvious to me, sorry.

> 
> Currently, there is no proper way to mark cleanup().  Neither __init,
> __exit, __devinit nor __devexit can be used there.
> 
> 
> Takashi

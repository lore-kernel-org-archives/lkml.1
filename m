Return-Path: <linux-kernel-owner+w=401wt.eu-S1761779AbXJTS2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761779AbXJTS2K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 14:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbXJTS15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 14:27:57 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:48717
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755896AbXJTS15 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 14:27:57 -0400
Message-Id: <471A56B3020000780003F5C8@public.id2-vpn.continvity.gns.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Sat, 20 Oct 2007 19:27:47 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <sam@ravnborg.org>
Cc: <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>,
       <zippel@linux-m68k.org>, <david-b@pacbell.net>,
       <linux-kernel@vger.kernel.org>, <rdunlap@xenotime.net>
Subject: Re: 2.6.23-git Kconfig regression
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'll try to, but it may take some time. Jan

>>> Sam Ravnborg <sam@ravnborg.org> 10/20/07 6:50 PM >>>
Jan - I assume you will look into this.

And thanks to David/Randy for narrowing this down.

Thanks,

	Sam

On Fri, Oct 19, 2007 at 09:25:55PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 19 Oct 2007, David Brownell wrote:
> 
> > > My (quick, meaning that I may have missed something) testing
> > > indicates that the problem is in the patches attached.
> > 
> > Yes, reverting this seems to resolve the problem:
> > 
> > > a5bf3d891a6a0fb5aa122792d965e3774108b923
> > >
> > > Change kconfig behavior so that mixing bool and tristate config settings in
> > > a choice is possible and has the desired effect of offering just the
> > > tristate options individually if the choice gets set to M, and a normal
> > > boolean selection if the choice gets set to Y.
> > 
> > Reverting this patch also fixes a second problem that I didn't
> > mention:  various dependent options couldn't be enabled.
> > 
> > Again in drivers/usb/gadget/Kconfig, examples include the
> > ability to configure the Ethernet gadget to act as an RNDIS
> > peripheral; or enabling Mass Storage gadget debug options.
> > 
> > 
> > Good sleuthing, and thanks!
> > 
> > Now we just need to see that patch reverted before RC1... I don't
> > know how Linus deals with all his LKML mail, so I cc'd him in
> > the hope that direct messages get through a bit faster.
> 
> Ok, I'll revert it, but wanted to make sure that the parties that pushed 
> the change are aware of this.
> 
> 		Linus 


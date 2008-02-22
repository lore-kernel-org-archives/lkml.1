Return-Path: <linux-kernel-owner+w=401wt.eu-S936334AbYBVAb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936334AbYBVAb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936009AbYBVAae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:30:34 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51940 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936006AbYBVAaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:30:30 -0500
Date: Fri, 22 Feb 2008 02:29:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080222002945.GF28328@cs181133002.pp.htv.fi>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <m3tzk1q3rt.fsf@maximus.localdomain> <20080221233144.6368712c@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080221233144.6368712c@core>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 11:31:44PM +0000, Alan Cox wrote:
> On Fri, 22 Feb 2008 00:38:14 +0100
> Krzysztof Halasa <khc@pm.waw.pl> wrote:
> 
> > Linus Torvalds <torvalds@linux-foundation.org> writes:
> > 
> > > I'm personally of the opinion that a lot of checkpatch "fixes" are 
> > > anything but. That mainly concerns fixing overlong lines
> > 
> > Perhaps we should increase line length limit, 132 should be fine.
> > Especially useful with long printk() lines and long arithmetic
> > expressions.
> 
> Agreed. The fact I'm having to fix bugs introduced by incorrect printk
> wrapping confirms that for printk strings at least it is overzealous.
> 
> I'm all for it complaining about
> 
>   printk(KERN_FOO "<90 chars>", foo, bar + 37);
> 
> type bits when the foo, bar should be underneath to be visible but for
> straight quoted text too long it should not warn and try to get the text
> folded.

I think it should warn, but people have to be aware of the following:
- checkpatch errors are for stuff that really has to be fixed
- checkpatch warnings are for stuff that should be looked at
- the goal is not 0 checkpatch warnings but readable and bugfree code

A nice property of checkpatch is that it encourages to look closer at 
code like the following (it warns about the volatile):

		if (!netif_queue_stopped(netdev)) {
			netif_stop_queue(netdev);
			barrier();
			if ((((((volatile u16)nesnic->sq_tail)+(nesnic->sq_size*2))-nesnic->sq_head) & (nesnic->sq_size - 1)) != 1) {
				netif_start_queue(netdev);
				goto sq_no_longer_full;
			}
		}

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


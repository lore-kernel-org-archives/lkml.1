Return-Path: <linux-kernel-owner+w=401wt.eu-S936470AbYEUTDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936470AbYEUTDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbYEUTDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:03:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756483AbYEUTDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:03:11 -0400
Date: Wed, 21 May 2008 12:02:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Takashi Iwai <tiwai@suse.de>
cc: Rene Herman <rene.herman@keyaccess.nl>, alsa-devel@alsa-project.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] HG -> GIT migration
In-Reply-To: <s5hfxsbo5nv.wl%tiwai@suse.de>
Message-ID: <alpine.LFD.1.10.0805211155130.3081@woody.linux-foundation.org>
References: <Pine.LNX.4.61.0805201314190.1798@tm8103-a.perex-int.cz> <200805211430.06653.linux@audioscience.com> <Pine.LNX.4.61.0805210805080.1798@tm8103-a.perex-int.cz> <s5hve18vtml.wl%tiwai@suse.de> <483415E7.5080402@keyaccess.nl> <s5hfxsbx27f.wl%tiwai@suse.de>
 <48341DF5.4090307@keyaccess.nl> <s5habijww7r.wl%tiwai@suse.de> <48344271.3090700@keyaccess.nl> <s5hy763ve5n.wl%tiwai@suse.de> <alpine.LFD.1.10.0805210908460.3081@woody.linux-foundation.org> <s5htzgrvbvo.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211003170.3081@woody.linux-foundation.org>
 <s5hfxsbo5nv.wl%tiwai@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 May 2008, Takashi Iwai wrote:
> 
> >  - cherry-pick it. Is it a small, simple patch that you want, but that 
> >    isn't really worth pulling in all the other stuff that you simply don't 
> >    know?
> > 
> >    This isn't wrong. It shouldn't be *common*, but it's not wrong to have 
> >    the same patch in two different branches. It makes sense if it is 
> >    something you really want, but it's still not important or complex 
> >    enough to actually mege everything else!
> 
> Hm, that's what I didn't consider seriously.  I thought cherry-picking
> patches may cause merge errors easily.

Cherry-picking can certainly cause merge errors, but not generally very 
often.

Cherry-picking by definition will obviously apply the *same* patch to two 
different branches, and as a result, when you merge, that merge will 
generally be totally clean. So a trivial merge that succeeds without you 
even noticing is actually the common case.

But you can certainly get merge failures where you then have to fix things 
up if there were *other* changes to that same area. At that point, you end 
up with two different branches that changed the same few lines 
differently, and it doesn't matter if then _some_ of the changes were 
identical - the fact that others were not is enough to cause a merge 
conflict.

If cherry-picking is an uncommon situation, the merge problems are not 
going to show up (and when they do, they'll generally be simple to 
resolve, especially if you limit cherry-picking to simple fixes). But if 
you do a *lot* of cherry-picking, and you cherry-pick big changes, then 
yes, you'll start hitting merge problems.

So cherry-picking is fine if you do it (a) fairly seldom and (b) just to 
small patches, because then the upsides of cherry-picking (easy to get a 
single fix without merging everything else) are bigger than the downsides 
(the potential merge problems later).

IOW, think of cherry-picking as just another tool. It has upsides and 
downsides. It's not "wrong" per se, but you can use it the wrong way. You 
shouldn't use a hammer on a screw, and you shouldn't use cherry-picking 
for big and complex stuff.

			Linus

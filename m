Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbYKLSSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbYKLSSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYKLSSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:18:31 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:34239 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYKLSSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:18:30 -0500
Date: Wed, 12 Nov 2008 19:19:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Isaku Yamahata <yamahata@valinux.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Tony Luck <tony.luck@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix section type conflict in arch/ia64/xen/xen_pv_ops.c
Message-ID: <20081112181940.GA15614@uranus.ravnborg.org>
References: <49133E11.8050607@goop.org> <20081106214848.GA3579@uranus.ravnborg.org> <s5hk5bazonk.wl%tiwai@suse.de> <20081111081552.GA10955%yamahata@valinux.co.jp> <s5hd4h2zndh.wl%tiwai@suse.de> <20081111085617.GD10955%yamahata@valinux.co.jp> <4919C43F.3030009@goop.org> <s5hej1iyx4x.wl%tiwai@suse.de> <4919D33C.3030101@goop.org> <s5hprl2uls1.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hprl2uls1.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 08:04:30PM +0100, Takashi Iwai wrote:
> At Tue, 11 Nov 2008 10:47:24 -0800,
> Jeremy Fitzhardinge wrote:
> > 
> > Takashi Iwai wrote:
> > > At Tue, 11 Nov 2008 09:43:27 -0800,
> > > Jeremy Fitzhardinge wrote:
> > >   
> > >> Isaku Yamahata wrote:
> > >>     
> > >>> Here is.
> > >>>
> > >>> __initdata and const cannot be always a happy pair and
> > >>> x86 xen has the potential issue.
> > >>> This patch simply removes const from data with __initdata
> > >>> under arch/x86/xen/.
> > >>>   
> > >>>       
> > >> No, I think the proper fix is to use __initconst.
> > >>     
> > >
> > > The problem is that it depends on gcc version which section it goes.
> > > Thus __initconst could break some gcc versions as well.
> > >   
> > 
> > Why?  __initconst explicitly puts it in .init.rodata.
> 
> Hrm, right, that's what __initconst does.  Just confused.
> Then I'm wondering in which case __initconst can be broken...
> Sam?  Do you have any particular reports?

I have only got reports that __initconst causes gcc build failure
on powerpc 64 bit.
So for x86 it should be safe to use __initconst.

	Sam

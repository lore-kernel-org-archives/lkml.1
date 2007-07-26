Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbXGZAEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbXGZAEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 20:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbXGZAEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 20:04:38 -0400
Received: from mx1.suse.de ([195.135.220.2]:41927 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbXGZAEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 20:04:37 -0400
Date: Wed, 25 Jul 2007 17:07:05 -0700
From: Greg KH <gregkh@suse.de>
To: Gabriel C <nix.or.die@googlemail.com>, Dave Hansen <haveblue@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc1-mm1
Message-ID: <20070726000705.GB21056@suse.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <6bffcb0e0707251148m219d1c9fqb557d3e5364f679b@mail.gmail.com> <20070725185328.GA28199@uranus.ravnborg.org> <46A7A1EF.8060307@zytor.com> <46A7B983.90407@googlemail.com> <46A7BB12.7060504@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A7BB12.7060504@googlemail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 11:05:22PM +0200, Gabriel C wrote:
> Gabriel C wrote:
> > H. Peter Anvin wrote:
> >> Sam Ravnborg wrote:
> >>> On Wed, Jul 25, 2007 at 08:48:50PM +0200, Michal Piotrowski wrote:
> >>>> On 25/07/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/
> >>>>>
> >>>>>
> >>>> Andi, this might be interesting for you
> >>>>
> >>>> make allmodconfig
> >>>> make
> >>>> [...]
> >>>> WARNING: Absolute relocations present
> >>>> Offset     Info     Type     Sym.Value Sym.Name
> >>>> c02041b3 00705601   R_386_32 c0308aa8  _sdata
> >>> Who did spit out this warning. Can you please provide make V=1
> >>> where we see the lines preceeding the warning.
> >>>
> >>> And config please.
> >>>
> >> config: "make allmodconfig"
> >>
> >> System.map would be more interesting, especially what is at 0xc02041b3.
> > 
> > I get here :
> > 
> > WARNING: Absolute relocations present
> > Offset     Info     Type     Sym.Value Sym.Name
> > c0202e73 00703601   R_386_32 c03071bc  _sdata
> > 
> > $ grep c03071bc System.map
> > c03071bc R __tracedata_end
> > c03071bc A _sdata
> 
> 
> Guessing is this patch ?
> 
> gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch:           __tracedata_end = .;
> gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch:+  _sdata = .;                     /* End of text section */

This patch is a horrible hack to try to see if kobjects are static and
not dynamically created.

Dave, any ideas what is happening here?

thanks,

greg k-h

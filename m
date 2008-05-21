Return-Path: <linux-kernel-owner+w=401wt.eu-S1765710AbYEUTGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765710AbYEUTGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYEUTGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:06:23 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38680 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbYEUTGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:06:22 -0400
Date: Wed, 21 May 2008 21:06:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: benh@kernel.crashing.org, Linux-Arch <linux-arch@vger.kernel.org>,
       linux-m32r@ml.linux-m32r.org, takata@linux-m32r.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Luke Browning <LukeBrowning@us.ibm.com>
Subject: Re: [PATCH 1/2] Add thread_info_cache_init() to all archs
Message-ID: <20080521190659.GB12638@uranus.ravnborg.org>
References: <20080410032354.90CB1DDF0F@ozlabs.org> <20080413171953.bde5e9ac.akpm@linux-foundation.org> <1208133506.6958.82.camel@pasglop> <20080413191338.9776ebd0.akpm@linux-foundation.org> <1208491086.6958.381.camel@pasglop> <20080417211905.8ff769fa.akpm@linux-foundation.org> <1208501061.6958.394.camel@pasglop> <1211392585.8297.218.camel@pasglop> <20080521114147.59ca3551.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521114147.59ca3551.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 11:41:47AM -0700, Andrew Morton wrote:
> On Wed, 21 May 2008 13:56:25 -0400 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > 
> > On Fri, 2008-04-18 at 16:44 +1000, Benjamin Herrenschmidt wrote:
> > > > > so what
> > > > > about the patch below ?
> > > > 
> > > > I like it, but the compiler won't ;)
> > > > 
> > > > > If you're ok, I'll re-send with appropriate sob
> > > > > & adapted powerpc part.
> > > > 
> > > > Sure.
> > > > 
> > > > > +void __init __attribute__((weak) thread_info_cache_init(void)
> > > >
> > 
> > Back to this old subject...
> > 
> > I'm having reports that this is not working...
> > 
> > gcc is seeing the empty weak function and is optimizing it out
> > before it gets a chance to link to the arch provided one.
> > 
> > This would affect that and the other one next to it..
> > 
> > That seems pretty bad... it causes nasty crashes as we end up having no
> > idea what the compiler decided to generate... I suppose we could keep
> > the weak stubs out of the file where they are called but that sucks.
> > 
> > ie. This is some form of gcc 4.1.1
> > 
> > Is that a known problem ? A gcc issue ? Not sure what is expected from
> > those weak functions.
> 
> yup, gcc bug.  Discussed recently on lkml, "Subject: Re: huge gcc
> 4.1.{0,1} __weak problem".  I don't think anything ended up happening
> about it though.

It was discussed to add some run-time checks for this issue.
But the examples given were a bit fluffy so I never integrated anything
i kbuild to detect this.

As this is only a bug for const weak functions they could be made non-const
if they are seldomly used?

	Sam

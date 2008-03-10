Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYCJVt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYCJVt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYCJVtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:49:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbYCJVtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:49:18 -0400
Date: Mon, 10 Mar 2008 14:48:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com
Subject: Re: [PATCH 1/6] gxfb: create DC/VP/FP-specific handlers rather than
 using readl/writel
Message-Id: <20080310144842.593d1b80.akpm@linux-foundation.org>
In-Reply-To: <20080310173544.171183fc@ephemeral>
References: <20080308204826.0d399caf@ephemeral>
	<20080310142405.e8b92156.akpm@linux-foundation.org>
	<20080310173544.171183fc@ephemeral>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 17:35:44 -0400
Andres Salomon <dilinger@queued.net> wrote:

> On Mon, 10 Mar 2008 14:24:05 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sat, 8 Mar 2008 20:48:26 -0500
> > Andres Salomon <dilinger@queued.net> wrote:
> > 
> > > +#define read_dc(reg)		readl(par->dc_regs + (reg))
> > > +#define write_dc(reg, val)	writel((val), par->dc_regs + (reg))
> > > +
> > > +#define read_vp(reg)		readl(par->vid_regs + (reg))
> > > +#define write_vp(reg, val)	writel((uint32_t) (val), \
> > > +					par->vid_regs + (reg))
> > > +
> > > +#define read_fp(reg)		readl(par->vid_regs + (reg))
> > > +#define write_fp(reg, val)	writel((uint32_t) (val), \
> > > +					par->vid_regs + (reg))
> > > +
> > 
> > Not very nice, sorry.  They're macros, and macros rather suck.  And they
> > implicitly rely upon the caller having some variable called "par" in scope.
> > 
> > It would be much nicer to do
> > 
> > /*
> >  * documentation goes here
> >  */
> > static inline u32 read_dc(struct geodefb_par *par, int reg)
> > {
> > 	return readl(par->dc_regs, reg);
> > }
> > 
> > no?
> 
> I can change it if you'd like (although.. sigh.)
> 
> However, it's a lot of extra passing around of the 'par' without any
> good reason.  Normal I prefer inline functions to macros as well, but
> I don't see the point here.
>  

It'll generate the same (or similar) code in both versions.

Code is written once and is read thousands of times, so we should optimise
for readers, not writers.  And I do think that being conventional here
helps readability, even if it does add a bit more source code.


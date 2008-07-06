Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbYGFVL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbYGFVL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbYGFVLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:11:50 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42012 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757623AbYGFVLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:11:49 -0400
Date: Sun, 6 Jul 2008 23:12:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Beulich <jbeulich@novell.com>, stable@kernel.org, llipavsky@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move __attribute__((__cold__)) functions back into final .text section
Message-ID: <20080706211234.GA7425@uranus.ravnborg.org>
References: <48590F41.76E4.0078.0@novell.com> <20080701231717.047d580a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701231717.047d580a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 11:17:17PM -0700, Andrew Morton wrote:
> On Wed, 18 Jun 2008 12:36:01 +0100 "Jan Beulich" <jbeulich@novell.com> wrote:
> 
> > Due to the addition of __attribute__((__cold__)) to a few symbols
> > without adjusting the linker scripts, those symbols currently may end
> > up outside the [_stext,_etext) range, as they get placed in
> > .text.unlikely by (at least) gcc 4.3.0. This may confuse code not only
> > outside of the kernel, symbol_put_addr()'s BUG() could also trigger.
> > Hence we need to add .text.unlikely (and for future uses of
> > __attribute__((__hot__)) also .text.hot) to the TEXT_TEXT() macro.
> > 
> > Issue observed by Lukas Lipavsky.
> > 
> > Cc: Lukas Lipavsky <llipavsky@suse.cz>
> > Signed-off-by: Jan Beulich <jbeulich@novell.com>
> > 
> > ---
> >  include/asm-generic/vmlinux.lds.h |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > --- linux-2.6.26-rc6/include/asm-generic/vmlinux.lds.h	2008-04-17 04:49:44.000000000 +0200
> > +++ 2.6.26-rc6-hot-cold-text/include/asm-generic/vmlinux.lds.h	2008-06-18 12:19:22.000000000 +0200
> > @@ -204,6 +204,7 @@
> >   * during second ld run in second ld pass when generating System.map */
> >  #define TEXT_TEXT							\
> >  		ALIGN_FUNCTION();					\
> > +		*(.text.hot)						\
> >  		*(.text)						\
> >  		*(.ref.text)						\
> >  		*(.text.init.refok)					\
> > @@ -213,7 +214,8 @@
> >  	CPU_KEEP(init.text)						\
> >  	CPU_KEEP(exit.text)						\
> >  	MEM_KEEP(init.text)						\
> > -	MEM_KEEP(exit.text)
> > +	MEM_KEEP(exit.text)						\
> > +		*(.text.unlikely)
> >  
> >  
> >  /* sched.text is aling to function alignment to secure we have same
> > 
> 
> So this is now in Sam's
> git+ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git.
> But it is not in the present linux-next.  Either because Sam added it
> after Stephen pulled Sam's tree, or because something screwed up.
> 
> So I'll now be dropping it.  Sam, please ensure that it gets into
> 2.6.26 and 2.6.25.x (IMO).

I have added a Cc: <stable@kernel.org> so the stable team should pick
it when applied to -linus.

	Sam

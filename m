Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbZDJKzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbZDJKzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762390AbZDJKzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:55:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:44843 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764129AbZDJKzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:55:20 -0400
Subject: Re: [PATCH 09/30] x86_64: ifdef out struct thread_struct::ip
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matt Helsley <matthltc@us.ibm.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, hch@infradead.org,
       torvalds@linux-foundation.org
In-Reply-To: <20090410092000.GG17962@elte.hu>
References: <20090410023522.GJ27788@x200.localdomain>
	 <20090410035328.GB29496@us.ibm.com> <1239336639.3036.20.camel@ht.satnam>
	 <20090410092000.GG17962@elte.hu>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 16:22:08 +0530
Message-Id: <1239360728.3012.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 11:20 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Thu, 2009-04-09 at 20:53 -0700, Matt Helsley wrote:
> > > On Fri, Apr 10, 2009 at 06:35:22AM +0400, Alexey Dobriyan wrote:
> > > > struct thread_struct::ip isn't used on x86_64, struct pt_regs::ip is used
> > > > instead. 
> > > > 
> > > > kgdb should be reading 0, but I can't check it.
> > > > 
> > > > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > > > ---
> > > > 
> > > >  arch/x86/include/asm/processor.h |    2 ++
> > > >  arch/x86/kernel/kgdb.c           |    2 +-
> > > >  2 files changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > --- a/arch/x86/include/asm/processor.h
> > > > +++ b/arch/x86/include/asm/processor.h
> > > > @@ -421,7 +421,9 @@ struct thread_struct {
> > > >  	unsigned short		fsindex;
> > > >  	unsigned short		gsindex;
> > > >  #endif
> > > > +#ifdef CONFIG_X86_32
> > > >  	unsigned long		ip;
> > > > +#endif
> > > >  #ifdef CONFIG_X86_64
> > > >  	unsigned long		fs;
> > > >  #endif
> > > 
> > > Do these make struct thread_struct behave better in cachelines (smaller,
> > > less aliasing)? Can we really fit more in the slab du jour?
> > > 
> > > Otherwise it seems like we're littering these structs with #ifdefs
> > > and not really saving anything. If these #ifdefs don't save any space why not 
> > > just put in a comment:
> > > 
> > > >  	unsigned long		ip; /* Used only on i386 */
> > > 
> > > Or maybe even:
> > > 
> > > 	union {
> > > 	  	unsigned long		ip; /* Used only on i386 */
> > > 	  	unsigned long		fs; /* Used only on x86_64 */
> > > 	};
> > > 
> > 
> > Can we do it like this:
> >   	unsigned long		ip_fs; /* ip: i386, fs: x86_64 */
> > 
> > I am using same variable for both cases, or we can use some better 
> > name than ip_fs. I am assuming either it is i386 or x86_64 machine 
> > ;-)
> 
> This is the least clean variant amongst all the suggestions.
> 

Yes, this was a wakeful call for you.

I send dozen of emails in last 24 hours to you for your feedback.

I do not need reply for this email. Please send reply for other emails.

Thanks,

--
JSR


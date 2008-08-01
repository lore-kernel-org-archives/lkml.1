Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbYHAVpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbYHAVpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbYHAVpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:45:33 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:24883 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754044AbYHAVpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:45:33 -0400
Date: Sat, 2 Aug 2008 06:44:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_elf_fdpic: Convert initial stack alignment to arch_align_stack().
Message-ID: <20080801214448.GA13448@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080728150501.GC16555@linux-sh.org> <20080728150359.GA16555@linux-sh.org> <20080728150430.GB16555@linux-sh.org> <27552.1217599279@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27552.1217599279@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 03:01:19PM +0100, David Howells wrote:
> Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > +	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
> > +	 * evictions by the processes running on the same package. One
> > +	 * thing we can do is to shuffle the initial stack for them, so
> > +	 * we give the architecture an opportunity to do so here.
> > +	 */
> >  #ifdef CONFIG_MMU
> > -	sp = bprm->p;
> > +	sp = arch_align_stack(bprm->p);
> >  #else
> > -	sp = mm->start_stack;
> > +	sp = arch_align_stack(mm->start_stack);
> 
> Ummm...  You're calling arch_align_stack() under NOMMU...  Is that really a
> good idea?
> 
Not particularly, no.

> You can't necessarily move the stack pointer without exiting the allocated
> region or shrinking the amount of stack space the executable asked for.  If
> you want to do this sort of thing, you need to tell the memory allocator what
> you're up to - or at the very least allocate some slack.
> 
Yes, that's a good point, and one that probably ought to be documented
alongside the initial alignment. I'll send an updated patch.

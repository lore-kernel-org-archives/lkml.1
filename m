Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbXHQXt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbXHQXt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 19:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbXHQXtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 19:49:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36428 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbXHQXtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 19:49:49 -0400
Date: Sat, 18 Aug 2007 05:32:25 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Thomas Gleixner <tglx@linutronix.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <1187394022.7007.133.camel@chaos>
Message-ID: <alpine.LFD.0.999.0708180526280.3666@enigma.security.iitk.ac.in>
References: <46C233CB.9000602@am.sony.com>  <1187132149.2618.2.camel@laptopd505.fenrus.org>
  <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in> 
 <20070817112253.e6a7cb33.akpm@linux-foundation.org> 
 <alpine.LFD.0.999.0708180011570.3666@enigma.security.iitk.ac.in> 
 <Pine.LNX.4.64.0708171413190.9635@schroedinger.engr.sgi.com> 
 <84144f020708171442x52b18722k2971ceef96d3e72@mail.gmail.com>
 <1187394022.7007.133.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Aug 2007, Thomas Gleixner wrote:

> On Sat, 2007-08-18 at 00:42 +0300, Pekka Enberg wrote:
> > On 8/18/07, Christoph Lameter <clameter@sgi.com> wrote:
> > > That was merged over my objections. IMHO ksize(NULL) should fail since we
> > > are determining the size of an unallocated object.
> > 
> > Agreed, especially as we have real zero-sized objects returned from
> > kmalloc() et al now.
> 
> Do we really ? 
> 
> If yes, who invented this 1980s reminiscence, where you got valid
> pointers for malloc(0) ?

No, not valid. Dereferencing it will oops. See ZERO_SIZE_PTR.

> This is completely stupid. You do not go into a bar and order an empty
> glass, just because you might eventually become thirsty later.

What we're doing presently is at least better than what SLAB did
previously (did return a valid pointer!), all this time :-)

I do agree with you in principle, of course. But it's not for the kind of
cases that you describe -- "kmalloc(0) just because I'd eventually want
to krealloc() it to something meaningful later". This was done because
there's a lot of lazy callsites that "don't want to write code for corner
cases explicitly". Sad, very sad, I say :-)

[ The krealloc() discussion on this thread came about when I noticed that
  it's the only callsite of ksize() that would reasonably / meaningfully
  want to deal with NULL ptrs, for whom I noticed (from Andrew's initial
  mail) that ksize(NULL) returned 0. As you know from the canonical
  semantics of realloc(), it _is_ supposed to deal with NULL ptrs, hence
  the discussion. ]


Satyam

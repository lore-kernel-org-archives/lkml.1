Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbYHMSRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYHMSRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYHMSQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:16:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:36784 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbYHMSQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:16:47 -0400
Date: Wed, 13 Aug 2008 11:16:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       hugh@veritas.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       briangrant@google.com, cgd@google.com, mbligh@google.com,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: pthread_create() slow for many threads; also time to revisit
 64b context switch optimization?
Message-ID: <20080813111635.657febc0@infradead.org>
In-Reply-To: <48A3222D.2060809@redhat.com>
References: <af8810200808121736q76640cc1kb814385072fe9b29@mail.gmail.com>
	<af8810200808121745h596c175bk348d0aaeeb9bcb45@mail.gmail.com>
	<20080813104445.GA24632@elte.hu>
	<20080813063533.444c650d@infradead.org>
	<48A2EE07.3040003@redhat.com>
	<20080813142529.GB21129@elte.hu>
	<48A2F157.7000303@redhat.com>
	<20080813151007.GA8780@elte.hu>
	<48A2FC17.9070302@redhat.com>
	<20080813154043.GA11886@elte.hu>
	<48A303EE.8070002@redhat.com>
	<alpine.LFD.1.10.0808131007530.3462@nehalem.linux-foundation.org>
	<48A3222D.2060809@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 11:04:29 -0700
Ulrich Drepper <drepper@redhat.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Linus Torvalds wrote:
> > Ulrich, I don't understand why you worry more about a _potential_
> > (and fairly unlikely) complaint, than about a real one today.
> 
> Of course I care.  All I try to do is to prevent going from one
> extreme (all focus on P4s) to the other (ignore P4s completely).

(fwiw as far as I know this is only about early 64 bit P4s, not later
generations)
> 
> Even ignoring this one case here, I think it's in any case useful for
> userlevel to tell the kernel that an anonymous memory region is needed
> for a stack.  This might allow better optimizations and/or security
> implementations.

yeah maybe we should also tell it we expect it to be used downwards.
Oh wait.. MAP_GROWSDOWN ?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

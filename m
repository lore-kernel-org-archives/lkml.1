Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbYGQVxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbYGQVxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYGQVxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:53:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:29260 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYGQVxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pKnpaP/PGiF43mj8+xTurJR+cna0lx1l7GvTcMbxISrCbbKn9GZprrCrspW00PoWdS
         VKCwf3TfZfuUWhpPPCqQ2PcMPLDKplpIC/WkGZRJdAL3PlnoCCh09f4bWfHkDVsYsFmk
         RALk8XLeilhK6EcK0Sm3K8/890X+b1J4wXxYc=
Date: Fri, 18 Jul 2008 01:50:59 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [PATCH 01/23] tracehook: add linux/tracehook.h
Message-ID: <20080717215059.GA12800@martell.zuzino.mipt.ru>
References: <20080717072541.F390E15411D@magilla.localdomain> <20080717072755.E2FBC15411D@magilla.localdomain> <20080717084818.GA5637@martell.zuzino.mipt.ru> <1216292812.28485.6.camel@elijah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216292812.28485.6.camel@elijah.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 01:06:52PM +0200, Petr Tesarik wrote:
> On Thu, 2008-07-17 at 12:48 +0400, Alexey Dobriyan wrote:
> > On Thu, Jul 17, 2008 at 12:27:55AM -0700, Roland McGrath wrote:
> > > The aim is to formalize and consolidate all the places that the core
> > > kernel code and the arch code now ties into the ptrace implementation.
> > > 
> > > These patches mostly don't cause any functional change.  They just
> > > move the details of ptrace logic out of core code into tracehook.h
> > > inlines, where they are mostly compiled away to the same as before.
> > 
> > > All that changes is that everything is thoroughly documented
> > 
> > This is fine.
> > 
> > > and any future reworking of ptrace, or addition of something new,
> > > would not have to touch core code all over, just change the tracehook.h
> > > inlines.
> > 
> > And this is suprising wish given one can't predict how exactly those
> > "future reworking" will look like.
> > 
> > > The new linux/ptrace.h inlines are used by the following patches in the
> > > new tracehook_*() inlines.  Using these helpers for the ptrace event
> > > stops makes it simple to change or disable the old ptrace implementation
> > > of these stops conditionally later.
> > 
> > Call them "utrace_*" from the start?
> 
> Ah, maybe justified, because I don't expect any other re-implementation
> of the same after utrace is finished, but -- there's still the old
> ptrace implementation, so _not_ mentioning utrace seems a bit better to
> me.

ptrace(2) will start calling utrace_* hooks and functions.

These tracehooks are generic and utrace is generic as well.


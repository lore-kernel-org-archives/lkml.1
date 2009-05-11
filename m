Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbZEKQfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbZEKQfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbZEKQfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:35:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47719 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbZEKQfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:35:14 -0400
Subject: Re: [RFC PATCH 0/3] generic hypercall support
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
In-Reply-To: <4A0824C2.4000109@gmail.com>
References: <20090505132005.19891.78436.stgit@dev.haskins.net>
	 <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com>
	 <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com>
	 <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com>
	 <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com>
	 <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws>
	 <4A0570B1.30401@novell.com> <4A071F1A.1090702@codemonkey.ws>
	 <4A0824C2.4000109@gmail.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Mon, 11 May 2009 11:35:12 -0500
Message-Id: <1242059712.29194.12.camel@slate.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 09:14 -0400, Gregory Haskins wrote:
> 
> >> for request-response, this is generally for *every* packet since
> you
> >> cannot exploit buffering/deferring.
> >>
> >> Can you back up your claim that PPC has no difference in
> performance
> >> with an MMIO exit and a "hypercall" (yes, I understand PPC has no
> "VT"
> >> like instructions, but clearly there are ways to cause a trap, so
> >> presumably we can measure the difference between a PF exit and
> something
> >> more explicit).
> >>   
> >
> > First, the PPC that KVM supports performs very poorly relatively
> > speaking because it receives no hardware assistance
> 
> So wouldn't that be making the case that it could use as much help as
> possible?

I think he's referencing Ahmdal's Law here. While I'd agree, this is
relevant only for the current KVM PowerPC implementations. I think it
would be short-sighted to design an IO architecture around that.

> >   this is not the right place to focus wrt optimizations.
> 
> Odd choice of words.  I am advocating the opposite (broad solution to
> many arches and many platforms (i.e. hypervisors)) and therefore I am
> not "focused" on it (or really any one arch) at all per se.  I am
> _worried_ however, that we could be overlooking PPC (as an example) if
> we ignore the disparity between MMIO and HC since other higher
> performance options are not available like PIO.  The goal on this
> particular thread is to come up with an IO interface that works
> reasonably well across as many hypervisors as possible.  MMIO/PIO do
> not appear to fit that bill (at least not without tunneling them over
> HCs)

I haven't been following this conversation at all. With that in mind...

AFAICS, a hypercall is clearly the higher-performing option, since you
don't need the additional memory load (which could even cause a page
fault in some circumstances) and instruction decode. That said, I'm
willing to agree that this overhead is probably negligible compared to
the IOp itself... Ahmdal's Law again.

-- 
Hollis Blanchard
IBM Linux Technology Center


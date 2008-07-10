Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbYGJPat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbYGJPat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760211AbYGJPah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:30:37 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:39695 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760207AbYGJPaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:30:35 -0400
Date: Thu, 10 Jul 2008 11:30:17 -0400
From: Theodore Tso <tytso@mit.edu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] simple dprobe like markers for the kernel
Message-ID: <20080710153017.GB25939@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	systemtap@sourceware.org
References: <1215638551.3444.39.camel__22002.9595810503$1215638656$gmane$org@localhost.localdomain> <y0m1w22qxoj.fsf@ton.toronto.redhat.com> <1215697794.3353.5.camel@localhost.localdomain> <20080710142208.GC1213@redhat.com> <1215700996.3353.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215700996.3353.30.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 09:43:16AM -0500, James Bottomley wrote:
> No ... I'm used to optimisation strangeness.  Again, I'm not trying to
> eliminate it because that would defeat the zero impact purpose.  I'm
> trying to build a system that can be useful without any impact.  The
> consequence is going to be that certain trace points can't be used
> because of the optimiser, but that's the tradeoff.  As long as the
> people placing the trace points are subject matter experts in the
> subsystem (and actually using them) everything should be OK.

So as I understand things, your light-weight tracepoints are designed
for very performance-sensitive code paths where we don't want to
disturbe the optimization in the deactivated state.  In
non-performance sensitive parts of the kernel, where cycle counting is
not so important, tracepoints can and probably should still be used.
So I don't think you were proposing eliminating the current kernel
markers in favor of this approach, yes?

When you said a tool could determine if the tracepoint had gotten
optimized away, or the variables were no longer present, I assume you
meant at compile time, right?  So with the right tool built into the
kbuild infrastructure, if we could simply print warnings when
tracepoints had gotten optimized away, that would make the your simple
tracepoints quite safe for general use, I would think.

	    	       	   	   	  	- Ted

P.S.  When you said that the current kernel markers are "a bit
heavyweight", how bad are they in practice?  Hundreds of cycles?  More?

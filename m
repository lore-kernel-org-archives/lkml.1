Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbYGJP5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbYGJP5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYGJP5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:57:24 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40928 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbYGJP5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:57:24 -0400
Subject: Re: [RFC] simple dprobe like markers for the kernel
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Theodore Tso <tytso@mit.edu>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <20080710153017.GB25939@mit.edu>
References: <1215638551.3444.39.camel__22002.9595810503$1215638656$gmane$org@localhost.localdomain>
	 <y0m1w22qxoj.fsf@ton.toronto.redhat.com>
	 <1215697794.3353.5.camel@localhost.localdomain>
	 <20080710142208.GC1213@redhat.com>
	 <1215700996.3353.30.camel@localhost.localdomain>
	 <20080710153017.GB25939@mit.edu>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 10:57:17 -0500
Message-Id: <1215705437.3353.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 11:30 -0400, Theodore Tso wrote:
> On Thu, Jul 10, 2008 at 09:43:16AM -0500, James Bottomley wrote:
> > No ... I'm used to optimisation strangeness.  Again, I'm not trying to
> > eliminate it because that would defeat the zero impact purpose.  I'm
> > trying to build a system that can be useful without any impact.  The
> > consequence is going to be that certain trace points can't be used
> > because of the optimiser, but that's the tradeoff.  As long as the
> > people placing the trace points are subject matter experts in the
> > subsystem (and actually using them) everything should be OK.
> 
> So as I understand things, your light-weight tracepoints are designed
> for very performance-sensitive code paths where we don't want to
> disturbe the optimization in the deactivated state.  In
> non-performance sensitive parts of the kernel, where cycle counting is
> not so important, tracepoints can and probably should still be used.
> So I don't think you were proposing eliminating the current kernel
> markers in favor of this approach, yes?

That's right ... I started from the position that the current markers
were too heavy for an I/O subsystem, but I'm sure they have many other
uses.

> When you said a tool could determine if the tracepoint had gotten
> optimized away, or the variables were no longer present, I assume you
> meant at compile time, right?

Yes and no.  Yes because a tool will be able to detect the problems, but
no if you're thinking an actual kernel compile would do it (unless some
tool is designed for this and integrated into the build ... the obvious
tool is systemtap, but that might cause some heartburn).

>   So with the right tool built into the
> kbuild infrastructure, if we could simply print warnings when
> tracepoints had gotten optimized away, that would make the your simple
> tracepoints quite safe for general use, I would think.

Yes ... but someone has to come up with the tool.  I suppose rebuilding
the line number matrix and finding the variables at the location is easy
mechanical dwarf stuff ... but it will give the kernel build a lot of
external dependencies it didn't have before.

Plus, this level of checking can only be done if dwarf is generated
(i.e. CONFIG_KERNEL_DEBUG_INFO is y).

James



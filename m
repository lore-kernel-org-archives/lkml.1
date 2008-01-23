Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYAWNVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYAWNVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 08:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYAWNV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 08:21:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbYAWNV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 08:21:26 -0500
Date: Wed, 23 Jan 2008 08:14:42 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Jon Masters <jcm@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: CONFIG_MARKERS
Message-ID: <20080123131442.GA6562@redhat.com>
References: <1201029235.18144.62.camel@perihelion> <y0modbdnt4e.fsf@ton.toronto.redhat.com> <20080123031005.GA16766@Krystal> <1201061860.25284.28.camel@perihelion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201061860.25284.28.camel@perihelion>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Jan 22, 2008 at 11:17:40PM -0500, Jon Masters wrote:
> On Tue, 2008-01-22 at 22:10 -0500, Mathieu Desnoyers wrote:
> > [...]
> > > > Is this an attempt to not set a marker for proprietary modules? [...]
> > > 
> > > I can't seem to find any discussion about this aspect.  If this is the
> > > intent, it seems misguided to me.  There may instead be a relationship
> > > to TAINT_FORCED_{RMMOD,MODULE}.  Mathieu?

> > On my part, its mostly a matter of not crashing the kernel when someone
> > tries to force modprobe of a proprietary module (where the checksums
> > doesn't match) on a kernel that supports the markers. Not doing so
> > causes the markers to try to find the marker-specific information in
> > struct module which doesn't exist and OOPSes.

But you have the wrong target: it is not proprietary modules that have
this risk but those built out-of-tree without checksums.  Maybe
oopsing in this case is not so bad; or the check could just limit itself to
FORCED_MODULE.


> > Christoph's point of view is rather more drastic than mine : it's not
> > interesting for the kernel community to help proprietary modules writers,
> > so it's a good idea not to give them marker support. (I CC'ed him so he
> > can clarify his position).
> Right. I thought that was your collective opinion

Another way of looking at this though is that by allowing/encouraging
proprietary module writers to include markers, we and their users get
new diagnostic capabilities.  It constitutes a little bit of opening
up, which IMO we should reward rather than punish.


- FChE

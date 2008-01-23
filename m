Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbYAWEST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbYAWEST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 23:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYAWESD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 23:18:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939AbYAWESB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 23:18:01 -0500
Subject: Re: CONFIG_MARKERS
From: Jon Masters <jcm@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20080123031005.GA16766@Krystal>
References: <1201029235.18144.62.camel@perihelion>
	 <y0modbdnt4e.fsf@ton.toronto.redhat.com>  <20080123031005.GA16766@Krystal>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Tue, 22 Jan 2008 23:17:40 -0500
Message-Id: <1201061860.25284.28.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 22:10 -0500, Mathieu Desnoyers wrote:
> * Frank Ch. Eigler (fche@redhat.com) wrote:
> > 
> > Jon Masters <jcm@redhat.com> writes:
> > 
> > > I notice in module.c:
> > >
> > > #ifdef CONFIG_MARKERS
> > > 	if (!mod->taints)
> > > 		marker_update_probe_range(mod->markers,
> > > 			mod->markers + mod->num_markers, NULL, NULL);
> > > #endif
> > >
> > > Is this an attempt to not set a marker for proprietary modules? [...]
> > 
> > I can't seem to find any discussion about this aspect.  If this is the
> > intent, it seems misguided to me.  There may instead be a relationship
> > to TAINT_FORCED_{RMMOD,MODULE}.  Mathieu?
> > 
> > - FChE
> 
> On my part, its mostly a matter of not crashing the kernel when someone
> tries to force modprobe of a proprietary module (where the checksums
> doesn't match) on a kernel that supports the markers. Not doing so
> causes the markers to try to find the marker-specific information in
> struct module which doesn't exist and OOPSes.
> 
> Christoph's point of view is rather more drastic than mine : it's not
> interesting for the kernel community to help proprietary modules writers,
> so it's a good idea not to give them marker support. (I CC'ed him so he
> can clarify his position).

Right. I thought that was your collective opinion, and I happen to
personally agree with you, but my question was more that you should be
explicitly comparing to whether it's proprietary and not just whether
the taints field is set - there are other flags in there too.

Jon.



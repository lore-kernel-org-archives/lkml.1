Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbYGWPdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbYGWPdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYGWPdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:33:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56458 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYGWPdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:33:05 -0400
Subject: Re: systemtap & backward compatibility, was Re: [RFC] systemtap:
	begin the process of using proper kernel APIs
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Rik van Riel <riel@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <20080723150434.GC11191@redhat.com>
References: <487E8CE4.70105@redhat.com>
	 <1216259391.3358.85.camel@localhost.localdomain>
	 <1216304290.5515.11.camel@localhost.localdomain>
	 <1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain>
	 <y0m7ibkjrcj.fsf@ton.toronto.redhat.com>
	 <1216325546.5515.63.camel@localhost.localdomain>
	 <20080717202634.GI18295@redhat.com>
	 <1216328769.5515.78.camel@localhost.localdomain>
	 <20080717213355.GJ18295@redhat.com>
	 <20080722140015.37628ea4@bree.surriel.com>
	 <20080723150434.GC11191@redhat.com>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 17:33:07 +0200
Message-Id: <1216827187.7257.189.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-23 at 11:04 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> I wrote:
> 
> > > [...] One significant requirement for us is to keep working with
> > > older kernels.  [...]
> 
> Maybe it's worth elaborating on why the need for backward
> compatibility is different for systemtap than for typical kernel-side
> code.
> 
> The bulk of systemtap is a user-space program, and it does very
> user-spacey things like parsing dwarf and invoking compilers, running
> network servers.  Soon it will include user-space libraries.  It is so
> different from the stuff normally found there that no one has AFAIK
> seriously proposed that the entire software be made part of the kernel
> git tree.  So it is an ordinary separate user-space package, built by
> users and distributors.
> 
> It does happen to *generate* kernel modules.  The way that such a
> module must interface with any particular kernel is naturally subject
> to the whims & desires of the kernel du jour.  This is why we have a
> mass of mechanism to try to automatically speak to each kernel version
> as appropriate.
> 
> It is desirable to minimize this mass for obvious reasons.  When a new
> upstream kernel comes out with a tasty new feature -- or a less tasty
> API rewrite -- we need to extend systemtap to support that too.  We
> cannot easily take old support away, because then the same user-space
> code base would no longer run against actually installed kernels.
> 
> To draw an analogy, systemtap is somewhat like low-level userspace
> code like glibc or syslogd or udevd.  I hope no one would seriously
> propose casually committing code to those packages that would make
> them unusable on prior kernel versions.  Accepting such a patch would
> require their maintainers to fork outright every time a kernel change
> occurs.
> 
> Things are good however if the low-level userspace changes are
> backward-compatible, so that the new kernel facility is used when
> present, but the software does not regress if it is not.  I believe
> this is what we need to aim for, even though it puts the bulk of the
> burden on systemtap (or glibc, or ...).
> 
> I hope this fills in some of the gaps in the background.

Why does a new version of stap have to work on ancient kernels?

A new gnome version requires a new gtk version, a new kde version
requires a new qt etc.. so why does a new stap not require a new kernel?

Why isn't only supporting the last few kernels, say for example as far
back as there are -stable series at the moment of release, good enough?

People who insist on running stale kernels are usually the same people
who run stale userspace - we call those enterprise people - so why can't
they run matching stale version of the kernel and stap?


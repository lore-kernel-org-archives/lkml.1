Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbYGWPGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbYGWPGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbYGWPGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:06:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbYGWPGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:06:13 -0400
Date: Wed, 23 Jul 2008 11:04:34 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: systemtap & backward compatibility, was Re: [RFC] systemtap: begin the process of using proper kernel APIs
Message-ID: <20080723150434.GC11191@redhat.com>
References: <487E8CE4.70105@redhat.com> <1216259391.3358.85.camel@localhost.localdomain> <1216304290.5515.11.camel@localhost.localdomain> <1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain> <y0m7ibkjrcj.fsf@ton.toronto.redhat.com> <1216325546.5515.63.camel@localhost.localdomain> <20080717202634.GI18295@redhat.com> <1216328769.5515.78.camel@localhost.localdomain> <20080717213355.GJ18295@redhat.com> <20080722140015.37628ea4@bree.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722140015.37628ea4@bree.surriel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

I wrote:

> > [...] One significant requirement for us is to keep working with
> > older kernels.  [...]

Maybe it's worth elaborating on why the need for backward
compatibility is different for systemtap than for typical kernel-side
code.

The bulk of systemtap is a user-space program, and it does very
user-spacey things like parsing dwarf and invoking compilers, running
network servers.  Soon it will include user-space libraries.  It is so
different from the stuff normally found there that no one has AFAIK
seriously proposed that the entire software be made part of the kernel
git tree.  So it is an ordinary separate user-space package, built by
users and distributors.

It does happen to *generate* kernel modules.  The way that such a
module must interface with any particular kernel is naturally subject
to the whims & desires of the kernel du jour.  This is why we have a
mass of mechanism to try to automatically speak to each kernel version
as appropriate.

It is desirable to minimize this mass for obvious reasons.  When a new
upstream kernel comes out with a tasty new feature -- or a less tasty
API rewrite -- we need to extend systemtap to support that too.  We
cannot easily take old support away, because then the same user-space
code base would no longer run against actually installed kernels.

To draw an analogy, systemtap is somewhat like low-level userspace
code like glibc or syslogd or udevd.  I hope no one would seriously
propose casually committing code to those packages that would make
them unusable on prior kernel versions.  Accepting such a patch would
require their maintainers to fork outright every time a kernel change
occurs.

Things are good however if the low-level userspace changes are
backward-compatible, so that the new kernel facility is used when
present, but the software does not regress if it is not.  I believe
this is what we need to aim for, even though it puts the bulk of the
burden on systemtap (or glibc, or ...).

I hope this fills in some of the gaps in the background.


- FChE

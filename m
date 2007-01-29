Return-Path: <linux-kernel-owner+w=401wt.eu-S1750975AbXA2TaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750975AbXA2TaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbXA2TaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:30:18 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:43257 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750975AbXA2TaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:30:17 -0500
Subject: Re: [PATCH] sysctl selinux: Don't look at table->de
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
In-Reply-To: <m14pq9lntk.fsf@ebiederm.dsl.xmission.com>
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
	 <20070127172410.2b041952.akpm@osdl.org>
	 <1169972718.17469.164.camel@localhost.localdomain>
	 <20070128003549.2ca38dc8.akpm@osdl.org> <20070128093358.GA2071@elte.hu>
	 <20070128095712.GA6485@elte.hu> <20070128100627.GA8416@elte.hu>
	 <20070128104548.a835d859.akpm@osdl.org>
	 <m1r6tfq7nv.fsf_-_@ebiederm.dsl.xmission.com>
	 <1170075866.8720.15.camel@moss-spartans.epoch.ncsc.mil>
	 <Pine.LNX.4.64.0701291017520.11801@d.namei>
	 <m14pq9lntk.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 29 Jan 2007 14:26:43 -0500
Message-Id: <1170098803.8720.143.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 10:55 -0700, Eric W. Biederman wrote:
> James Morris <jmorris@namei.org> writes:
> 
> > On Mon, 29 Jan 2007, Stephen Smalley wrote:
> >
> >> NAK.  Mapping all sysctls to a single security label prevents any kind
> >> of fine-grained security on sysctls, and current policies already make
> >> use of the current distinctions to limit access to particular sets of
> >> sysctls to particular processes.  As is, I'd expect breakage of current
> >> systems running SELinux from this patch, because (confined) processes
> >> that formerly only required access to specific sysctl labels will
> >> suddenly run into denials on the generic fallback label.
> >
> > Agreed, 100% NACK.
> >
> > Please don't just simply remove long-researched & analyzed MAC security 
> > which has been in the kernel for years, which is being used in the field 
> > for high assurance systems, because you neglected to consider it during a 
> > code cleanup.
> 
> Please don't shoot the messenger when a weakness is found in your code.

I'm not sure how breaking our code with your set of patches qualifies as
finding a weakness.  I will agree that the current handling of sysctl in
selinux is fragile and can be improved, but it did work (prior to your
patches).

> Systems that increase security without worry that their implementation
> is correct do not impress me, but I do understand that security has
> little to do with correctness and everything to do with making it
> _expensive_ for the other guy to do what he isn't supposed to.

I think you misunderstand; we are concerned about the correctness of our
implementation.  I think that possibly you are misunderstanding one of
the SELinux FAQ answers outside of its historical context (the initial
release of a proof-of-concept implementation of flexible MAC in Dec
2000).

> This code path was always in the selinux code for when /proc was
> compiled out.  I could see no way to preserve it so I removed
> it.
> 
> Not knowing if it was a problem, or if we needed to do something more
> I copied the people who did, at the first available opportunity.
> Before this code makes it's way into peoples production systems.

Which we appreciate, although it would be nice if you tried building
with selinux (and ideally testing with it) in the first place.

> Of course after all of the rants against path based security I was
> amazed to find a code path that was using exactly that in selinux.

To clarify, in this case, the pathname (relative to the root of proc) is
derived from the proc_dir_entry hierarchy and is thus not ambiguous or
mutable by userspace, unlike the pathname-based approaches that we have
criticized.  There is a difference.  But we are open to improving the
approach via explicit marking of the ctl_table entries with sufficient
information.

> I'm trying to make things correct, and simple and will be happy to
> work with you in a way to achieve what you need in a way that does
> not conflict with the rest of the kernel.

Good.

-- 
Stephen Smalley
National Security Agency


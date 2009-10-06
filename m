Return-Path: <linux-kernel-owner+w=401wt.eu-S933176AbZJFU0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbZJFU0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933145AbZJFU0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:26:02 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:51600 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933141AbZJFU0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:26:02 -0400
From: Frans Pop <elendil@planet.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [patch] kbuild: Improve version string logic
Date: Tue, 6 Oct 2009 22:25:22 +0200
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, torvalds@linux-foundation.org, hohndel@infradead.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910062146.00298.elendil@planet.nl> <1254858498.22426.41.camel@johannes.local>
In-Reply-To: <1254858498.22426.41.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910062225.24274.elendil@planet.nl>
X-OriginalArrivalTime: 06 Oct 2009 20:25:24.0698 (UTC) FILETIME=[22A053A0:01CA46C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a bit OT, but one last reply.

On Tuesday 06 October 2009, Johannes Berg wrote:
> > AFAIK it would be propagated into the package _name_, where
> > it is allowed. And even if it were part of the package version, it
> > would be in the "upstream" part of the version number, where it is
> > also allowed.
>
> That may all well be true. I wasn't even aware of the distinction
> between debian and upstream part of the version :)

The Debian part is everything after the last dash in a package version.

> I do, however, remember no end to trouble with autoversion and make-kpkg
> so eventually gave up on using it entirely.

Yes, problems with autoversion and make-kpkg I can understand as it makes 
the revision ID part of the package name, which is very simply not where 
you want it [1].

I stopped using make-kpkg for 2 reasons. First of all it is insanely 
complex. And second it used to always do a 'make clean' for every build, 
which meant a huge inefficiency during bisections and builds after minor 
changes; I understand that has been fixed though.

I was happy to discover the kernel's native deb-pkg target. There've been 
some improvements to that in recent kernels that make it quite powerful 
and flexible for building custom kernels as Debian packages.

Cheers,
FJP

[1] The deb-pkg target does the same, so autoversion is not usable with 
that either. What I do is manipulate the output of 'git describe' to set 
an ENVVAR that gets used as package version.

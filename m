Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbZJFQgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbZJFQgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbZJFQgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:36:41 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:57226 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756386AbZJFQgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:36:40 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.32-rc3
Date: Tue, 6 Oct 2009 18:36:01 +0200
User-Agent: KMail/1.9.9
Cc: hohndel@infradead.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <1254839931.24117.9.camel@dhohndel-mobl.amr.corp.intel.com> <1254839931.24117.9.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060808220.3432@localhost.localdomain>
In-reply-To: <alpine.LFD.2.01.0910060808220.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910061836.02726.elendil@planet.nl>
X-OriginalArrivalTime: 06 Oct 2009 16:36:03.0115 (UTC) FILETIME=[181567B0:01CA46A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Your kind of magical thinking leads to _problems_. It's literally been a
> problem that people stop bisecting, because they notice that they start
> testing kernels that have a version number before the release they
> already tested as good. Exactly because of your kind of linear thinking.

I do understand your point, but I'm not sure that it makes sense to take 
bisecting as the main criterium here. Bisection will always be confusing 
for users the first few times, whatever you put in the Makefile.

IMO it is more relevant that people who build and run pre-rc1 kernels get a 
clear distinction by default between their stable kernel and the (highly 
unstable) merge window one.
When a user compiles a kernel, the only thing that's relevant is what's in 
Makefile *at that time*, not where the branches that are merged in happen 
to originate.

Personally I always add a -rc0 in a local commit as soon as I pull any 
merge window changes (that commit gets dropped when you release -rc1).
Package versions are derived from git describe.

So I get (examples include local commits):
linux-image-2.6.31_31.g5e9d407_amd64.deb (.31 + 31 local changes)
linux-image-2.6.31.1_31.gb4adf51_amd64.deb
linux-image-2.6.32-rc0_7396-g02b51df_amd64.deb
linux-image-2.6.32-rc1_20.ge8343d5_amd64.deb
linux-image-2.6.32-rc1_154.gb157421_i386.deb
linux-image-2.6.32-rc3_18.g7e921a0_amd64.deb
linux-image-2.6.32-rc3_69.g7146bc5_amd64.deb

Of course this it makes no difference if you use 'make install', but for 
other cases I think having -rc0 in mainline first thing in the merge 
window would be useful. Especially for users who compile kernels from the 
git tarballs during the merge window (and are not aware of localversion).
Of course there are plenty of options to do whatever you want locally, but 
why not make it easy?


BTW, I've got a solution for bisection too: the versions in the Makefile 
get changed to something constant. And the package version is set equal to 
the bisection iteration. This ensures that I know exactly which kernels 
were build for the series and that I can always go back to a specific 
kernel if I need to retest for some reason.

E.g. (for a bisection covering .30-.31):
linux-image-2.6.31-bisect_1_amd64.deb
linux-image-2.6.31-bisect_2_amd64.deb
linux-image-2.6.31-bisect_3_amd64.deb
...

Cheers,
FJP

P.S. I use the deb-pkg target to build all my kernels. A wrapper script 
takes care of all the stuff mentioned above (and cross-compiling). For me 
the clean package management is worth the slight overhead.

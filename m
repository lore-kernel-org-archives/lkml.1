Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbZJOOmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbZJOOmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 10:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758073AbZJOOmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 10:42:43 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:65381 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757351AbZJOOmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 10:42:42 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
Date: Thu, 15 Oct 2009 16:42:03 +0200
User-Agent: KMail/1.9.9
Cc: David Rientjes <rientjes@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910150143.18755.elendil@planet.nl> <20091015090301.GC10546@elte.hu>
In-Reply-To: <20091015090301.GC10546@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910151642.05276.elendil@planet.nl>
X-OriginalArrivalTime: 15 Oct 2009 14:42:05.0668 (UTC) FILETIME=[AA5D8A40:01CA4DA5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 October 2009, Ingo Molnar wrote:
> > Distro kernels generally have their own naming schemes.
> > Debian uses: 2.6.30-2-amd64 (<version>-<ABI>-<flavor>)
> > Fedora uses: 2.6.30.5-43.fc11.i586
> >
> > And those kernel versions implicitly already contain the information
> > that they are not vanilla kernels. So a "+" suffix is totally
> > redundant.
>
> It's not "totally redundant" _AT ALL_.
>
> "2.6.30+-2-amd64" tells us that not only do we have the usual per distro

But it would not be "2.6.30+-2-amd64"; it would become "2.6.30-2-amd64+", 
which IMO sucks.

> patches on top of vanilla .30 (which patches can be found in the deb or
> src.rpm), but we _ALSO_ have extra _vanilla kernel_ commits since
> v2.6.30.

This is where you are wrong. Yes, the patches are in the deb [1], but how 
do they end up there? The distro patches themselves are also maintained in 
an SCM, quite possibly as a branch from mainline, and the package 
maintainers will build *from* that SCM. So *the distro patches themselves* 
will trigger the "+".

You simply cannot distinguish between "extra vanilla kernel commits" 
and "distro commits" in a tree. Both are changes since the tagged release; 
both will trigger the "+", which makes the "+" meaningless.

Also, any distro cherry-picks upstream patches from later versions 
as "distro patches" (at least, that's the case for over 90% of the patches 
in Debian stable kernels). And we already know such patches are included 
whenever we see a distro kernel version, so I still think having the "+" 
does not add any meaningful information.

> Besides, distros building on kernels inbetween -rc's is very rare.

True. Which is why we shouldn't be adding the "+".

> If it happens it's sufficiently unusual to alert users to that fact via
> the '+' sign. The '+' sign will go away if a distro uses a precise
> upstream version.

But that's the whole point. It does not!
Even if they _only_ add their packaging infrastructure on top and have no 
patches that affect the the kernel itself (which is unlikely), they would 
still end up with the "+" because the commit(s) that add the packaging 
infrastructure make the tree unequal to the tagged release.

Cheers,
FJP

[1] Actually they are in the .diff.gz, which contains all changes relative 
to the original tarball, but I understand what you mean.

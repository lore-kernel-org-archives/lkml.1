Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbYHAPnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbYHAPnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYHAPnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:43:10 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:24259 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbYHAPnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:43:09 -0400
In-Reply-To: <20080731231206.80940fba.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Sam Ravnborg <sam@ravnborg.org>, Tony Breeds <tony@bakeyournoodle.com>
MIME-Version: 1.0
Subject: Re: [BUILD-FAILURE] 2.6.27-rc1-mm1 - allyesconfig build fails on powerpc
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF6FEAA9CB.C1447125-ONC1257498.004ECFF8-C1257498.00561AEF@de.ibm.com>
From: Peter 1 Oberparleiter <Peter.Oberparleiter@de.ibm.com>
Date: Fri, 1 Aug 2008 17:40:29 +0200
X-MIMETrack: Serialize by Router on D12ML066/12/M/IBM(Release 7.0.2FP2HF322 | September
 26, 2007) at 01/08/2008 17:42:09,
	Serialize complete at 01/08/2008 17:42:09
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote on 01.08.2008 08:12:06:
> On Fri, 1 Aug 2008 15:29:36 +1000 Tony Breeds <tony@bakeyournoodle.com> 
wrote:
> > On Thu, Jul 31, 2008 at 06:13:28PM +0530, Kamalesh Babulal wrote:
> > > Hi Andrew,
> > > 
> > > make allyesconfig with 2.6.27-rc1-mm1 kernel on powerpc fails 
> > > with build error
> > 
> > <snip>
> > 
> > Turning off GCOV "fixes" this.  Not really the best solution but at
> > least it narrows doen the search effort.
> 
> Thanks.
> 
> > Peter,
> >    Can you have a look at how this can be fixed, if at all?
> > 
> 
> Am not terribly happy with the state of the gcov patches.  They STILL
> leave thousands of dead symlinks lying around after `make mrproper'


This is caused by patch

    gcov-create-links-to-gcda-files-in-build-directory.patch

which can be simply removed as it is no longer needed since patch

    gcov-add-gcov-profiling-infrastructure-revert-link-changes.patch

has been added to -mm.

> and
> generally seem to muck up the kbuild system a bit, although nothing
> that a bit of Sam love wouldn't fix.

Hm, by now the only change to kbuild is the addition of gcc options
-fprofile-arcs/-ftest-coverage depending on the respective config
symbols. If there is anything else that should be changed, please
let me know.

> Plus it breaks the build on a few architectures (branch out of range,
> mainly), but that's a fairly minor thing which could even be worked
> around in Kconfig (disable the offending code if gcov is enabled)

Some of the problems caused/uncovered by enabling gcov profiling for
a kernel build on some architectures simply cannot be fixed by a change
to the kernel patch itself. I'm wondering if it would be possible
to disable this configuration option when specifying allyesconfig. That
way at least generic testing wouldn't be affected.


Regards,
  Peter

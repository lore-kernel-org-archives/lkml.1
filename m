Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZGXXPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZGXXPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 19:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZGXXPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 19:15:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:31621 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbZGXXPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 19:15:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,266,1246863600"; 
   d="scan'208";a="535764431"
Date: Fri, 24 Jul 2009 16:15:11 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: Peter Chubb <peterc@gelato.unsw.edu.au>, Sam Ravnborg <sam@ravnborg.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ia64: minor Makefile simplification through use of cc-ifversion
Message-ID: <20090724231511.GA20607@linux-os.sc.intel.com>
References: <200907232056.51064.elendil@planet.nl> <20090723212809.GB9488@merkur.ravnborg.org> <87ws5yoo44.wl%peterc@nicta.com.au> <200907242023.12478.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907242023.12478.elendil@planet.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 11:23:11AM -0700, Frans Pop wrote:
> On Friday 24 July 2009, Peter Chubb wrote:
> > >>>>> "Sam" == Sam Ravnborg <sam@ravnborg.org> writes:
> > Sam> The above change is correct.  But I really wonder if the original
> > Sam> code was correct?  Do we really only want to use the -mtune
> > Sam> options for this specific gcc version?  If this is indeed the
> > Sam> case this deserves a comment explaning this.
> >
> > I suspect it should be all compilers after this one.  -mtune=mckinley
> > didn't work very well in the early gcc 3 compilers and didn't exist in
> > version 2.
> 
> How would you like to handle that? As it is essentially a separate issue,
> my suggestion would be: apply my patch as is and then (if needed) commit
> a separate patch to fix the incorrect comparisons on top.

Between GCC version 3.4.0 and 4.3.3 (including 3.4.0 and 4.3.3), -mtune=merced is
implemented in GCC. Starting from 4.4.0, -mtune=merced is deprecated.

Even implemented in versions between 3.4.0 and 4.3.3, the -mtune=merced
feature has been broken in some of the versions. For example, GCC 4.1.2 reports
interanl tuning function errors during kernel building with -mtune=merced. Or GCC
Bugzilla 16130 reports another -mtune=merced issue on GCC 3.4.1.

So I would remove the -mtune=merced from IA64 kernel build. Without this option,
kernel on Merced will remain the same except losing an unstable and out-of-date
performance tunning feature.

Since GCC version 3.4.0, -mtune=mckinley has been implemented. The
-mtune=mckinley option functions the same as mtune=itanium2. And mtune=itanium2
is the default option. So we don't need to add mtune=mckinley either since its
been the default option in any GCC version which implements this option.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---
 arch/ia64/Makefile |    5 -----
 1 files changed, 5 deletions(-)

diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index 58a7e46..e7cbaa0 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -41,11 +41,6 @@ $(error Sorry, you need a newer version of the assember, one that is built from
 		ftp://ftp.hpl.hp.com/pub/linux-ia64/gas-030124.tar.gz)
 endif
 
-ifeq ($(call cc-version),0304)
-	cflags-$(CONFIG_ITANIUM)	+= -mtune=merced
-	cflags-$(CONFIG_MCKINLEY)	+= -mtune=mckinley
-endif
-
 KBUILD_CFLAGS += $(cflags-y)
 head-y := arch/ia64/kernel/head.o arch/ia64/kernel/init_task.o
 

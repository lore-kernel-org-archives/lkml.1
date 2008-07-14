Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbYGNWa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbYGNWa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbYGNWar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:30:47 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46782 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201AbYGNWar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:30:47 -0400
Subject: Re: [PATCH] init/version.c: Define version_string only if
	CONFIG_KALLSYMS is not defined.
From: Daniel Guilak <guilak@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       daniel@danielguilak.com
In-Reply-To: <20080714150731.e86295b2.randy.dunlap@oracle.com>
References: <1215552069.10304.6.camel@dguilak-desk>
	 <1216062286.6497.18.camel@dguilak-desk>
	 <20080714123858.2c42227f.randy.dunlap@oracle.com>
	 <1216070438.6497.27.camel@dguilak-desk>
	 <20080714150731.e86295b2.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 15:29:46 -0700
Message-Id: <1216074586.6497.37.camel@dguilak-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 15:07 -0700, Randy Dunlap wrote:
> On Mon, 14 Jul 2008 14:20:38 -0700 Daniel Guilak wrote:
> 
> > On Mon, 2008-07-14 at 12:38 -0700, Randy Dunlap wrote:
> > > On Mon, 14 Jul 2008 12:04:46 -0700 Daniel Guilak wrote:
> > > 
> > > > int Version_* is only used with ksymoops, which is only needed (according to
> > > > README and Documentation/Changes) if CONFIG_KALLSYMS is NOT defined.  Therefore
> > > > this patch defines version_string only if CONFIG_KALLSYMS is not defined.
> > > > 
> > > > Signed-off-by: Daniel Guilak <daniel@danielguilak.com>
> > > > ---
> > > >  init/version.c |    2 ++
> > > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > > 
> > > > Depends on "[PATCH] init/version.c: Silenced sparse warning by declaring the version string."
> > > > 
> > > > diff --git a/init/version.c b/init/version.c
> > > > index 041fd82..52a8b98 100644
> > > > --- a/init/version.c
> > > > +++ b/init/version.c
> > > > @@ -13,11 +13,13 @@
> > > >  #include <linux/utsrelease.h>
> > > >  #include <linux/version.h>
> > > >  
> > > > +#ifndef CONFIG_KALLSYMS
> > > >  #define version(a) Version_ ## a
> > > >  #define version_string(a) version(a)
> > > >  
> > > >  extern int version_string(LINUX_VERSION_CODE);
> > > >  int version_string(LINUX_VERSION_CODE);
> > > > +#endif
> > > >  
> > > >  struct uts_namespace init_uts_ns = {
> > > >  	.kref = {
> > > > -- 
> > > 
> > > Does not apply cleanly to linux-2.6.26, linux-next-20080714, or Linus-git-head.
> > > 
> > 
> > Did you apply "[PATCH] init/version.c: Silenced sparse warning by
> > declaring the version string." beforehand? I just applied it on the most
> > recent tree and I didn't have any issues.
> 
> Clearly I didn't apply that patch.  I missed anything saying that this was
> patch 2/2 in a dependent series.

Sorry about that, I should have been a bit more clear with it. Next
time I'll make sure to state that in the subject line. I stated the
dependency right before the diff message.

> > > and why do we ned both extern int version_string()
> > > and int version_string() ?
> > Because sparse was complaining that it wasn't prototyped or static.
> > There isn't a header file to put it in since it only exists to be a
> > kernel.
> 
> so the extern makes it be published in the symbol table, whereas a static
> would keep it private.  Is that correct?
> 
> and the second line (int version_string(LINUX_VERSION_CODE)) actually
> defines it.

Yes, that's exactly the idea behind it.

--Daniel


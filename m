Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYGNTDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYGNTDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 15:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYGNTDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 15:03:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54895 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbYGNTDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:03:23 -0400
Subject: Re: [PATCH] init/version.c: Silenced sparse warning by declaring
	the version string.
From: Daniel Guilak <guilak@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       torvalds@linux-foundation.org, daniel@danielguilak.com
In-Reply-To: <20080711121833.f03200e6.akpm@linux-foundation.org>
References: <1215552069.10304.6.camel@dguilak-desk>
	 <20080711121833.f03200e6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 14 Jul 2008 12:02:26 -0700
Message-Id: <1216062146.6497.15.camel@dguilak-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-11 at 12:18 -0700, Andrew Morton wrote:
> On Tue, 08 Jul 2008 14:21:09 -0700 Daniel Guilak <guilak@linux.vnet.ibm.com> wrote:
> 
> > Signed-off-by: Daniel Guilak <daniel@danielguilak.com>
> 
> Please always quote the warning or error message in the changelog when
> fixing it.  Although it's pretty obvious in this case.
> 
> >  init/version.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/init/version.c b/init/version.c
> > index 9d17d70..041fd82 100644
> > --- a/init/version.c
> > +++ b/init/version.c
> > @@ -16,6 +16,7 @@
> >  #define version(a) Version_ ## a
> >  #define version_string(a) version(a)
> >  
> > +extern int version_string(LINUX_VERSION_CODE);
> >  int version_string(LINUX_VERSION_CODE);
> >  
> >  struct uts_namespace init_uts_ns = {
> 
> hrm, what does this thing do?  Seems to define 
> 
> int Version_132634;
> 
> Then sticks that in the symbol table (and wastes a bit of bss).
> 
> Does anything use it?
> 
> Could it be made static?
> 
> 
﻿﻿Apparently it's only used by the ksymoops tool, which is not needed if
(according to README) the kernel is configured with CONFIG_KALLSYMS.

So I will submit a patch depending on this one that will define
version_string only if CONFIG_KALLSYMS is not defined, and hopefully
that will deal with the problem.

--Daniel Guilak


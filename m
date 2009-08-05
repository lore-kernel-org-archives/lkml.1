Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbZHEIOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbZHEIOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933737AbZHEIOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:14:16 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:61194 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072AbZHEIOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:14:15 -0400
Date: Wed, 5 Aug 2009 09:13:46 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>
Subject: Re: Please revert fc4c73554c9d93b3e495f2f7acae1323b0d5db84. Re:
	[PATCH 1/2] ftrace: Fix the conditional that updates $ref_func
Message-ID: <20090805081346.GA4983@console-pimps.org>
References: <21d7e9970908050013m71ce7500x1d04a591de21ca30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970908050013m71ce7500x1d04a591de21ca30@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 05:13:33PM +1000, Dave Airlie wrote:
> On Fri, Jul 24, 2009 at 2:16 AM, Matt Fleming<matt@console-pimps.org> wrote:
> > Fix the conditional that checks if we already have a $ref_func and that
> > the new function is weak. The code as previously checking whether either
> > condition was false, and we really need to only update $ref_func is both
> > cconditions are false.
> >
> 
> This breaks the powerpc build on Fedora.
> 
> When building on ppc64 this commit causes the links of drivers/hwmon/lm93.o
> to fail.
> 
> It introduces an undefined symbol
>                  U .LM93_IN_FROM_REG
> 
> that isn't produced when this patch is reverted
> 
> This was found when the Fedora kernel failed to build when I pulled in
> -rc5-git3.
> 
> can be seen at the end of:
> http://koji.fedoraproject.org/koji/getfile?taskID=1582002&name=build.log
> 
> So can we revert this (at this stage in -rc5 or maybe fix it).
> 
> Dave.
> 

Eek! So the patch actually causes recordmcount.pl to remove
LM_IN_FROM_REG from the object file? Sorry about that. That is not at
all something I would ever expect to happen. I'll see if I can recreate
this and try figure out what is going on.

Thanks for the report.

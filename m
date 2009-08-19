Return-Path: <linux-kernel-owner+w=401wt.eu-S1752428AbZHSSKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbZHSSKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZHSSKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:10:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33514 "EHLO mx1.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752041AbZHSSKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:10:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
X-Fcc: ~/Mail/linus
Cc: Rusty Russell <rusty@rustcorp.com.au>, Helge Deller <deller@gmx.de>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel segv with 2.6.31-rc6 ?
In-Reply-To: James Bottomley's message of  Tuesday, 18 August 2009 19:38:36 -0600 <1250645916.18426.12.camel@mulgrave.site>
References: <4A89CC4D.5040801@gmx.de>
	<1250549376.7858.96.camel@mulgrave.site>
	<200908181248.52572.rusty@rustcorp.com.au>
	<20090818050637.4C3E74730F@magilla.sf.frob.com>
	<1250640565.15079.3.camel@mulgrave.site>
	<20090819001424.4C1144730F@magilla.sf.frob.com>
	<1250643261.18426.8.camel@mulgrave.site>
	<20090819013124.7539E4730F@magilla.sf.frob.com>
	<1250645916.18426.12.camel@mulgrave.site>
X-Windows: form follows malfunction.
Message-Id: <20090819181041.7215E4730F@magilla.sf.frob.com>
Date: Wed, 19 Aug 2009 11:10:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Using ET_DYN would have made our life easier when trying to code the
> kernel module loader as well.  The basic problem is, of course, that
> this is simple on an x86, so it didn't matter that much for the initial
> implementation.  It just becomes less simple on anything else.

There are generic ways that ET_DYN is better for all, too.  
A little birdie told me it was all the fault of mips.
Anyway, water under the bridge.

> Well, since they're still making parisc machines, I assume you mean
> further back than when the production lines knocked off today?

I'm pretty sure you knew what I meant.

> So that leaves us stuck with the current implementation and still
> needing a solution for the duplicate section names?

Something like that.  Your fix makes module loading work again, so we
could just let /sys/module/*/{sections,notes}/ be missing on parisc
and see how long it takes anybody to complain, assuming you talk Rusty
out of his preference to change those error cases to refuse to load
the module.  OTOH, you said earlier that it was only some mistake that
produced multiple same-named sections to begin with, so you could just
try to fix that and then forget about it.

Finally, we could decide to really support the general case including
duplicate section names in these features.  That's really not very
hard to do, if we just completely change the interfaces for those
features.  e.g. instead of a /sys/module/*/sections directory, it
could just be a single file that contains lines of:

SHNDX 0xADDR NAME

For /sys/module/*/notes, no consumer really cares about the section
distinctions at all.  It would be easy enough just to have a single
pseudo-file that delivers all note sections concatenated together.
(In practice, there is usually only one note section at most anyway.)

Of course, such changes would be a new incompatible change to the
userland sysfs ABI, require compatibility concerns, etc.  It seems
unlikely anyone really wants to bother with all that.  It would be
more natural presentation of the info IMHO, but it hardly matters.


Thanks,
Roland

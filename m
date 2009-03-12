Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbZCLN1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbZCLN1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbZCLN0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:26:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33631 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbZCLN0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:26:50 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Phillips <phillips@phunq.net>, tux3@tux3.org,
       linux-kernel@vger.kernel.org
Subject: Re: Tux3 report: Tux3 Git tree available
From: Andi Kleen <andi@firstfloor.org>
References: <200903110925.37614.phillips@phunq.net>
	<20090311114211.89eed5b8.akpm@linux-foundation.org>
	<200903112238.55864.phillips@phunq.net>
	<20090311230713.d4710050.akpm@linux-foundation.org>
Date: Thu, 12 Mar 2009 14:24:20 +0100
In-Reply-To: <20090311230713.d4710050.akpm@linux-foundation.org> (Andrew Morton's message of "Wed, 11 Mar 2009 23:07:13 -0700")
Message-ID: <87zlfqeuwr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

As a general comment I'm not sure it really makes all that sense to
integrate anywhere without recovery functionality because noone can
really use in that state. I think it would be better to concentrate
reviewing/testing efforts on other submitted file systems that
actually work and are used today (like ceph or nilfs2)

Also to be honest the estimate of adding btree directories in 3kLOC
of code seems very optimistic.

>
>> > - count_range() is an unsuitable identifier for a kernel-wide symbol.
>> >   Please review all global symbols in the fs, ensure that they are
>> >   prefixed with "tux3_".  Or make them static, of course.
>> 
>> This symbol is only supposed to be shared between separate compilation
>> units within fs/tux3, not be visible outside our module.  How do we do
>> that?
>
> You can't.  Bear in mind that we want the allyesconfig kernel to link
> and run, and that includes tux3.  So do it manually by prefixing
> everything with tux3_ or whatever.  (does it need the "3"?)

AFAIK it could be done by using special linker scripts for the sublinks.
But I'm not sure it's worth it because that would require listing of the symbols
in some file. Would need some Makefile magic.

For modules I also had the "namespace" patches some time ago which implemented
simple namespace support. Should probably resurrect that.

> I'm not sure why, really - I have vague memories of Linus having an
> episode...  It seems an OK construct if used tastefully.  Although it
> does make it easy to hide nasty surprises.

The original reason was gcc 2.95, but that got dropped.

Then I loved to use c99 mixed code/declarations (imho putting the declaration
near the code improves readability), but someone pointed
out that having them makes it harder to catch patch mistakes when
patch puts a hunk in the wrong place.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

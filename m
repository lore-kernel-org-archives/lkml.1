Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbXD0AL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbXD0AL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbXD0AL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:11:26 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbXD0ALY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:11:24 -0400
Message-ID: <46313F99.6080402@zytor.com>
Date: Thu, 26 Apr 2007 17:11:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <20070426162530.bc30a1bb.akpm@linux-foundation.org>
In-Reply-To: <20070426162530.bc30a1bb.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 26 Apr 2007 18:49:05 -0400 Ulrich Drepper <drepper@redhat.com> wrote:
>>
>> If the tv_nsec value of either of the elements of the utimes parameter to utimensat() is UTIME_OMIT no update of that respective value is performed.
> 
> ITYM "If the value of either of the elements..."
> 
> +#define UTIME_NOW	((1l << 30) - 1l)
> +#define UTIME_OMIT	((1l << 30) - 2l)
> 
> OK, so there's no collision on ts_nsec if unnormalised timespecs are
> disallowed.
> 
> But there's a potential collision on ts_sec?  Do we know what date that
> corresponds to?

"If the tv_nsec value" implies that these magic numbers have no impact
on these.

I'm a bit leery of abusing the timespec value like this, though.  A
flags field seem like it would be cleaner.

Something else... if we're dickering with these interfaces, shouldn't we
allow setting atime as well?

	-hpa

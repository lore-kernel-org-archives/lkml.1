Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbXH2TAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbXH2TAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbXH2TAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:00:34 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54025 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbXH2TAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:00:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
	<20070828230459.GA15937@infradead.org>
	<m1r6lnb4ha.fsf@ebiederm.dsl.xmission.com>
	<46D4CC81.4060400@zytor.com>
	<m1d4x7aysz.fsf@ebiederm.dsl.xmission.com>
	<20070829114604.242b976c@the-village.bc.nu>
	<m1absa5kid.fsf@ebiederm.dsl.xmission.com>
	<46D5ACA1.3090503@zytor.com>
Date: Wed, 29 Aug 2007 13:00:07 -0600
In-Reply-To: <46D5ACA1.3090503@zytor.com> (H. Peter Anvin's message of "Wed,
	29 Aug 2007 10:28:01 -0700")
Message-ID: <m18x7u4154.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>
>> My hypothesis.  No one cares now.
>>
>> My observation. The way we have been maintaining the binary sysctl
>> side of things using it is asking for your application to be broken in
>> subtle and nasty ways.
>>
>
> I suspect the right thing to do is simply to make a list of the supported binary
> sysctls, and automatically verify those numbers.  Doing that would alleviate
> these concerns, wouldn't break anything, and isn't really that hard to do.

Well the list is currently 1200 lines long, with wild cards in it.
See sysctl_check.c in the -mm tree.  I think I have finally found
all of the binary sysctl numbers that are currently in use but I may
have missed something.  Although that can probably be trimmed a bit
now that a number of those sysctls have been identified as impossibly
and always broken

The real problem is that sysctl uses different functions for the
binary path and the proc path.  Those functions return the same
data in two different forms.  When those functions diverge we
have problems.  As I recently found with about 42 of the netfilter
sysctls.

The concern is that no one uses these things so no one tests these
things, and no one complains about these things so the code bit rots.
When the code bit rots we can return the wrong value or set the
wrong value in the kernel or skip locking or skip permission checks
or various other nasty things.

Hmm.  Thinking about it I guess so far I have found about 10% of
the binary sysctls to have actual implementation problems.  Not my
idea of well maintained code.

Eric

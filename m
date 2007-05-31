Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbXEaNbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbXEaNbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbXEaNax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:30:53 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50207 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbXEaNaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:30:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, nanhai.zou@intel.com,
       asit.k.mallick@intel.com, keith.packard@intel.com,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86_64 irq: check remote IRR bit before migrating level triggered irq (v2)
References: <20070517230324.GB8089@linux-os.sc.intel.com>
	<m1d50h5irm.fsf@ebiederm.dsl.xmission.com>
	<200705311401.02221.ak@suse.de>
Date: Thu, 31 May 2007 07:29:43 -0600
In-Reply-To: <200705311401.02221.ak@suse.de> (Andi Kleen's message of "Thu, 31
	May 2007 14:01:02 +0200")
Message-ID: <m1y7j53yuw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> On Thursday 31 May 2007 13:34:21 Eric W. Biederman wrote:
>> 
>> On x86_64 kernel, level triggered irq migration gets initiated in the context
>> of that interrupt(after executing the irq handler) and following steps are
>> followed to do the irq migration.
>
> What's the confidence level in the patch? Is it a .22 candidate?

Yes.

I just ran it for a little while and nothing fell over, and level
triggered irqs continued to migrate.  So it's not horribly broken.

Outside of implementation errors the worst case that can happen with
this code is the current behavior, with a small slow down.

So since I can not reproduce the original problem I would appreciate
an eyeball or two more just to make certain I reimplemented this
correctly and didn't do anything stupid.   But I don't expect anything
to be found.  The code is pretty straight forward.

Eric

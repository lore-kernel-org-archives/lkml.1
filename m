Return-Path: <linux-kernel-owner+w=401wt.eu-S1423076AbXBUUSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423076AbXBUUSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423077AbXBUUSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:18:24 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33764 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423076AbXBUUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:18:23 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com>
	<20070221114737.a09be761.akpm@linux-foundation.org>
Date: Wed, 21 Feb 2007 13:13:16 -0700
In-Reply-To: <20070221114737.a09be761.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 21 Feb 2007 11:47:37 -0800")
Message-ID: <m1odnn1d7n.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 21 Feb 2007 14:31:41 -0500
> Chuck Ebbert <cebbert@redhat.com> wrote:
>> What is the status of:
>> 
>>
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-simplfy-__assign_irq_vector.patch
>>
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-handle-irqs-pending-in-irr-during-irq-migration.patch
>
> That's mainly an Andi decision.  Let's cc him.
>
>> They fix a serious bug that causes machines to freeze up
>> or just run very slowly.
>> 
>> I'd like to see these in -stable if possible.
>
> They're not even in mainline yet.

If you don't have it you at least want the patch below.  It generally
makes the bug non-fatal.

I'm still working my way through possible fixes...  Although the
patch in question is close, and normally fixes it in my utmost
paranoia I can still find problems with it.

Eric


commit 2fb12a9bca5ad9aa6dcd2c639b4a7656a8843ef8
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Tue Feb 13 13:26:25 2007 +0100

    [PATCH] x86-64: survive having no irq mapping for a vector
    
    Occasionally the kernel has bugs that result in no irq being found for a
    given cpu vector.  If we acknowledge the irq the system has a good chance
    of continuing even though we dropped an irq message.  If we continue to
    simply print a message and not acknowledge the irq the system is likely to
    become non-responsive shortly there after.
    
    AK: Fixed compilation for UP kernels
    
    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    Signed-off-by: Andi Kleen <ak@suse.de>
    Cc: "Luigi Genoni" <luigi.genoni@pirelli.com>
    Cc: Andi Kleen <ak@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


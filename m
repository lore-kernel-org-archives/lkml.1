Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZFXMkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZFXMkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZFXMkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:40:24 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:59783 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbZFXMkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:40:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19010.7860.240329.636708@cargo.ozlabs.ibm.com>
Date: Wed, 24 Jun 2009 22:40:20 +1000
From: Paul Mackerras <paulus@samba.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: register_timer_hook use in arch/sh/oprofile
In-Reply-To: <20090624122533.GA9510@linux-sh.org>
References: <20090624131104.705c828d@skybase>
	<20090624112929.GB2079@linux-sh.org>
	<20090624121750.GB20564@elte.hu>
	<20090624122533.GA9510@linux-sh.org>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt writes:

> Yes, that all works fine. My comment was more in reference to the
> hardware performance counters that don't have IRQs of their own, which
> still need to be tied in to the perf_counter API.

For them you would need to check in hw_perf_counter_init() that
counter->attr.sample_period is zero, and fail with an -EINVAL error if
it isn't.

Paul.

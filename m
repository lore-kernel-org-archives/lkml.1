Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbYGVT4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbYGVT4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYGVTzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:55:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbYGVTzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:55:54 -0400
To: Avi Kivity <avi@qumranet.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       kvm@vger.kernel.org
Subject: Re: [patch 0/4] Port KVM-trace to tracepoints
References: <20080717155724.897537670@polymtl.ca>
	<48862A30.7050701@qumranet.com>
	<y0mabg991c3.fsf@ton.toronto.redhat.com>
	<488635A7.2030609@qumranet.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 22 Jul 2008 15:54:04 -0400
In-Reply-To: <488635A7.2030609@qumranet.com> (Avi Kivity's message of "Tue, 22 Jul 2008 22:31:51 +0300")
Message-ID: <y0m4p6h8zkz.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@qumranet.com> writes:

> [...]
>> Have you considered using trace_mark() directly - eliminating the
>> KVM_TRACEN() middlemen?
> [...]
> Using trace_mark() directly -- looking at it, seems to fit the
> requirements exactly.  Should have looked at it earlier.  Is there a
> way to get a list of all markers?

>From kernel-space, I can't find just now an API for listing them, but
there probably is / could be one.

>From user-space, lttng tools can probably do it.  systemtap can too:
     % stap -l 'kernel.mark("*")'

You could prototype binary tracing thusly:
     % stap -e 'probe kernel.mark("kvm_foobar") { 
         printf("%4b%4b%4b", # three 4-byte ints
                cpu(), $arg1, $arg2)
       }'

> Perhaps the kvmtrace marker->relay integration should be made a marker
> feature, since there is nothing specific to kvm in it.

Right, I believe something like that is in the lttng patch suite.


- FChE

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbZCRC3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbZCRC3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 22:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZCRC3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 22:29:13 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58433 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbZCRC3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 22:29:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18880.23662.233043.833458@drongo.ozlabs.ibm.com>
Date: Wed, 18 Mar 2009 13:29:02 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/11] perf_counter: revamp syscall input ABI
In-Reply-To: <20090317220421.336322251@chello.nl>
References: <20090317215606.037073805@chello.nl>
	<20090317220421.336322251@chello.nl>
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> The hardware/software classification in hw_event->type became a little strained
> due to the addition of tracepoint tracing.
> 
> Instead split up the field and provide a type field to explicitly specify the
> counter type, while using the event_id field to specify which event to use.
> 
> Raw counters still work as before, only the raw config now goes into raw_event.

Interesting idea, but why not also use it to express the distinction
between generic and raw hardware events ids?  Why not add a
PERF_TYPE_RAW_HARDWARE to this list:

> + * hw_event.type
> + */
> +enum perf_event_types {
> +	PERF_TYPE_HARDWARE		= 0,
> +	PERF_TYPE_SOFTWARE		= 1,
> +	PERF_TYPE_TRACEPOINT		= 2,
> +};

and get rid of the raw bit?  That way, hw_event.raw_event is unique
for every different event, whereas the way you have it, you still need
to include the raw bit to get a unique id.

Paul.

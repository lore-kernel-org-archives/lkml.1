Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbYB1WOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbYB1WOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759551AbYB1WOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:14:34 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:44157 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759247AbYB1WOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:14:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAIjAxkdMQWRV/2dsb2JhbACBVqxx
Date: Thu, 28 Feb 2008 17:14:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Jason Baron <jbaron@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 1/2] add ALL_CPUS option to stop_machine_run()
Message-ID: <20080228221430.GA22958@Krystal>
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com> <20080227190519.GA14335@Krystal> <20080228163303.GA6195@redhat.com> <47C73121.2000109@qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <47C73121.2000109@qualcomm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:12:19 up 17 days, 18:12,  4 users,  load average: 0.46, 0.56,
	0.65
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Max Krasnyanskiy (maxk@qualcomm.com) wrote:
> Jason Baron wrote:
>> -allow stop_mahcine_run() to call a function on all cpus. Calling  
>> stop_machine_run() with a 'ALL_CPUS' invokes this new behavior.
>>  stop_machine_run() proceeds as normal until the calling cpu has
>>  invoked 'fn'. Then, we tell all the other cpus to call 'fn'.
>
> Jason, we're actually trying to reduce the usage of the stop_machine in 
> general. It's a very big hammer that kills latencies and stuff. It'd be 
> nice if we did not introduce any more dependencies on it. I guess in some 
> case there is simply no other way to handle what need to do. But please 
> think twice
> (or more :)).
>
> Max
>
>

I have a "more complex" immediate value implementation that does not
depend on such heavy lock. I made this simplified version because Rusty
preferred it, although I say from the beginning that it kills interrupt
latency. I could propose the atomic, nmi-safe version directly if enough
people are in favor of it.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

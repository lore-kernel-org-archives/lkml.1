Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbYCBXcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbYCBXcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 18:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYCBXcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 18:32:07 -0500
Received: from ozlabs.org ([203.10.76.45]:50758 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbYCBXcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 18:32:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Subject: Re: [patch 1/2] add ALL_CPUS option to stop_machine_run()
Date: Mon, 3 Mar 2008 10:32:02 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Kathy Staples <kathy.staples@au1.ibm.com>
References: <20080202210828.840735763@polymtl.ca> <20080228163303.GA6195@redhat.com> <47C73121.2000109@qualcomm.com>
In-Reply-To: <47C73121.2000109@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031032.03160.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 February 2008 09:09:37 Max Krasnyanskiy wrote:
> Jason Baron wrote:
> > -allow stop_mahcine_run() to call a function on all cpus. Calling
> >  stop_machine_run() with a 'ALL_CPUS' invokes this new behavior.
> >  stop_machine_run() proceeds as normal until the calling cpu has
> >  invoked 'fn'. Then, we tell all the other cpus to call 'fn'.
>
> Jason, we're actually trying to reduce the usage of the stop_machine in
> general. It's a very big hammer that kills latencies and stuff. It'd be
> nice if we did not introduce any more dependencies on it. I guess in some
> case there is simply no other way to handle what need to do. But please
> think twice (or more :)).

Well, by definition modifying an immediate value should be very rare, so it's 
a reasonable candidate.

But stop_machine needs work.  It should not be as heavy as it is.

Cheers,
Rusty.

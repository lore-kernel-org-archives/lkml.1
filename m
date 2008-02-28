Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbYB1Jd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbYB1Jd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 04:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbYB1JdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 04:33:19 -0500
Received: from smtp-out.google.com ([216.239.45.13]:43320 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYB1JdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 04:33:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=Os2wHiC2KuLqUMvm1WHoaIkws+4cKd6hWqUaAHTJZociLZTxyY3I+cqHJErraWEfl
	Db3UfH1XRZfeZZyIFd2Tw==
Date: Thu, 28 Feb 2008 01:32:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       oleg@tv-sign.ru, rostedt@goodmis.org, maxk@qualcomm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
In-Reply-To: <20080228031710.3405e405.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802280129580.15900@chino.kir.corp.google.com>
References: <20080227222103.673194000@chello.nl> <20080228075010.GA28781@elte.hu> <20080228020808.3fd22f77.pj@sgi.com> <20080228090847.GA1133@elte.hu> <20080228031710.3405e405.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Paul Jackson wrote:

> So we provide them some init script mechanisms that make it easy to
> set this up, which includes moving every task (not many at the low
> numbered init script time this runs) that isn't pinned (doesn't have
> a restricted Cpus_allowed) into the boot cpuset, conventionally
> named /dev/cpuset/boot.
> 

Should the kernel refuse to move some threads, such as the migration 
or watchdog kthreads, out of the root cpuset where the mems can be 
adjusted to disallow access to the cpu to which they are bound?  This is 
a quick way to cause a crash or soft lockup.

		David

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbYEYOmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbYEYOmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 10:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYEYOm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 10:42:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:10489 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbYEYOm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 10:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=mAUauRJEA69LoSGThAM38RqUlsucyuS6ghS1rl8N7jP9yHCUMaJ/8W+1PiEAxSvVUpFPrP/rk+mL73ROeF4DvQgSWz4RIkH22zRKZD29t4SYISg8mLpu6YQveJmgGve7hT+BizDQxO1UNU5fH/K3knnzxLocyQLDZCp1ctZ+ioc=
Date: Sun, 25 May 2008 17:30:13 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: [PATCH] kmemcheck: SMP support
Message-ID: <20080525173013.3102949b@daedalus.pq.iki.fi>
In-Reply-To: <19f34abd0805230719j1ce0e2eje6da7c1f963fdf75@mail.gmail.com>
References: <20080523141759.GA1833@damson.getinternet.no>
	<19f34abd0805230719j1ce0e2eje6da7c1f963fdf75@mail.gmail.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 16:19:43 +0200
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> Oops, forgot to put you on Cc. I thought you might find this
> interesting as well... :-)

Yes, thanks. My opinion is that mmiotrace can live well enough with
runtime-disabling extra cpus when tracing starts. Multi-cpu effects to
hardware access are not really in the focus but seeing the access in
the first place. I'd rather wait to see if the per-cpu page table
feature starts to evolve.

I quickly read through your code and tried to come up with race
scenarios, but failed. Ok, one question which might be far fetched:
is there a window for things to go wrong, when one cpu has faulted
and is submitting the NMI, but another cpu is managing cpus' online
state at the time? Is there a place in the cpu state management
that might fault at a point where cpu maps are inconsistent?
I doubt, but I don't know. And of course this could be a problem
only when something is bringing cpus on- or offline.

Btw. isn't reserving a cpumask_t variable from the stack discouraged
because it might have to deal with thousands of cpus and consume a
lot of memory?


Thanks.

> ---------- Forwarded message ----------
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Fri, May 23, 2008 at 4:17 PM
> Subject: [PATCH] kmemcheck: SMP support
> To: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: linux-kernel@vger.kernel.org
> 
> 
> Hi,
> 
> This works on real hw, but not on qemu. It seems to get stuck waiting for one
> of the atomic values to change. Don't know why yet, it might just be yet
> another bug in qemu... (we've hit at least two of them so far. And they were
> real bugs too.)
> 
> But do you think this approach is feasible? It will kill interactivity,
> that's for sure, though only when kmemcheck is run-time enabled and number
> of CPUs > 1 (the more the worse).
> 

-- 
Pekka Paalanen
http://www.iki.fi/pq/

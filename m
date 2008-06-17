Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbYFQO0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbYFQO0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYFQO0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:26:24 -0400
Received: from [194.117.236.238] ([194.117.236.238]:34036 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbYFQO0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:26:24 -0400
Date: Tue, 17 Jun 2008 17:26:04 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: tzanussi@gmail.com, linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 2/3] Better interface for hooking early initcalls.
Message-ID: <20080617172604.740a4ae3@linux360.ro>
In-Reply-To: <20080617140742.GD10316@Krystal>
References: <20080615180508.71d1cbcc@linux360.ro>
	<20080617140742.GD10316@Krystal>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008 10:07:42 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> I am not sure it's worth it trying to define a generic "early"
> initcall, since definition of "how early it is" may change with time.
> 
> Currently, it's earlier than SMP init, but later on, it could become
> earlier than mm init. If there are only few users of this, and given
> that they must be designed "knowing" how early they are initialized
> wrt other subsystems, I think it would make sense to call them
> directly from the init code without putting them in a "early
> initcall" category.

I designed this to be "same as other core initcalls, but before SMP".
This isn't a replacement we could use for very early code, such as
kmem_cache_init(). Take into account that CPU hotplug requires this, as
stated in the docs, I quote:
> You need to call register_cpu_notifier() from your init function.
> Init functions could be of two types: 
> 1. early init (init function called when only the boot processor is online).
> 2. late init (init function called _after_ all the CPUs are online).

> why not do_one_initcall(*call); ?

I haven't actually tried do_one_initcall() at that point, but it seemed
it messed up with preemption and IRQs. Will check and see if causes any
problems and resubmit if it works. But you do have a point, debugging
should be doable for these initcalls too.
 
> Mathieu
> 

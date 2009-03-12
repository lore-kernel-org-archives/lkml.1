Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbZCLDhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbZCLDhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 23:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZCLDhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 23:37:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbZCLDhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 23:37:10 -0400
Date: Wed, 11 Mar 2009 20:32:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] ring-buffer: only allocate buffers for online cpus
Message-Id: <20090311203222.7515107d.akpm@linux-foundation.org>
In-Reply-To: <20090312023936.696105567@goodmis.org>
References: <20090312023720.144716747@goodmis.org>
	<20090312023936.696105567@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 22:37:24 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: save on memory
> 
> Currently, a ring buffer was allocated for each "possible_cpus". On
> some systems, this is the same as NR_CPUS. Thus, if a system defined
> NR_CPUS = 64 but it only had 1 CPU, we could have possibly 63 useless
> ring buffers taking up space. With a default buffer of 3 megs, this
> could be quite drastic.
> 
> This patch changes the ring buffer code to only allocate ring buffers
> for online CPUs.  If a CPU goes off line, we do not free the buffer.
> This is because the user may still have trace data in that buffer
> that they would like to look at.
> 
> Perhaps in the future we could add code to delete a ring buffer if
> the CPU is offline and the ring buffer becomes empty.
> 
> ...
>
> +#ifdef CONFIG_HOTPLUG
> +#ifdef CONFIG_HOTPLUG
> +#ifdef CONFIG_HOTPLUG
> +#ifdef CONFIG_HOTPLUG
> +#ifdef CONFIG_HOTPLUG

CONFIG_HOTPLUG_CPU

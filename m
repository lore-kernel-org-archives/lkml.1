Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbYHKPHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbYHKPHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYHKPHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:07:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38038 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYHKPHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:07:35 -0400
Date: Mon, 11 Aug 2008 08:05:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dario Faggioli <raistlin@linux.it>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@osdl.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC 1/1][PATCH] POSIX SCHED_SPORADIC implementation for tasks
 and groups
Message-Id: <20080811080545.d8f42601.randy.dunlap@oracle.com>
In-Reply-To: <1218465906.6450.42.camel@Palanthas>
References: <1218465906.6450.42.camel@Palanthas>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 16:45:06 +0200 Dario Faggioli wrote:

> diff --git a/init/Kconfig b/init/Kconfig
> index b678803..97fbdfc 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -323,6 +323,44 @@ config CPUSETS
>  config HAVE_UNSTABLE_SCHED_CLOCK
>  	bool
>  
> +config POSIX_SCHED_SPORADIC
> +	bool "SCHED_SPORADIC POSIX scheduling policy support"
> +	default n
> +	help
> +	  Enable the SCHED_SPORADIC POSIX scheduling policy, which mimics
> +	  the behaviour of the Sporadic Server, a well known mechanism
> +	  to schedule aperiodic or sporadic tasks in periodic-based fixed
> +	  priorit real-time systems.

	  priority

> +
> +	  To get details about the SCHED_SPORADIC scheduling policy refer to
> +	  "The Open Group Base Specifications Issue 6", IEEE Std 1003.1,
> +	  2004 Edition.
> +
> +	  [http://www.opengroup.org/onlinepubs/009695399/nfindex.html]
> +
> +config SCHED_SPORADIC_REPL_MAX
> +	int "Maximum number of pending recharges"
> +	range 1 1000
> +	depends on POSIX_SCHED_SPORADIC
> +	default 10
> +	help
> +	  Let you chose the maximum number of recharges that can be

	  Lets you choose

> +	  pending at a given time instant for a SCHED_SPORADIC task
> +	  (or task group if group scheduling is configured).
> +
> +	  The kernel data structure handling the SCHED_SPORADIC scheduling
> +	  policy for tasks and groups contains a buffer of pending
> +	  replenishment this size large.
> +	  For tasks it is dynamically allocated when SCHED_SPORADIC is set
> +	  as the scheduling policy of the task, while for group it is created
> +	  as soon as the group itself is allocated.
> +
> +	  Anyway, since this is going to cause some memory overhead, it is
> +	  wise to not set this to a too much high value.

	  wise not to set this to a very high value.	// or some other rewording

> +	  The best value depends on the characteristics of the application
> +	  you are going to use, but probably a value from 10 to 20 is
> +	  suitable for the most of the situations.
> +
>  config GROUP_SCHED
>  	bool "Group CPU scheduler"
>  	depends on EXPERIMENTAL


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/

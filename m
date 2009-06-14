Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbZFNJmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbZFNJmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 05:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbZFNJl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 05:41:56 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51674 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbZFNJl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 05:41:56 -0400
Date: Sun, 14 Jun 2009 18:41:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counters: start documenting HAVE_PERF_COUNTERS requirements
Message-ID: <20090614094111.GE832@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier@gentoo.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <4A328DBE.2030905@oracle.com> <1244827632-24218-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244827632-24218-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 01:27:12PM -0400, Mike Frysinger wrote:
> diff --git a/tools/perf/design.txt b/tools/perf/design.txt
> index 860e116..f71e0d2 100644
> --- a/tools/perf/design.txt
> +++ b/tools/perf/design.txt
> @@ -440,3 +440,18 @@ by this process or by another, and doesn't affect any counters that
>  this process has created on other processes.  It only enables or
>  disables the group leaders, not any other members in the groups.
>  
> +
> +Arch requirements
> +-----------------
> +
> +If your architecture does not have hardware performance metrics, you can
> +still use the generic software counters based on hrtimers for sampling.
> +
> +So to start with, in order to add HAVE_PERF_COUNTERS to your Kconfig, you
> +will need at least this:
> +	- asm/perf_counter.h - a basic stub will suffice at first
> +	- support for atomic64 types (and associated helper functions)
> +	- set_perf_counter_pending() implemented
> +
> +If your architecture does have hardware capabilities, you can override the
> +weak stub hw_perf_counter_init() to register hardware counters.

It would be nice to see this in arch/Kconfig instead, as that tends to
provide a centralized checklist for new features, especially when they
are non-trivial. At least I found the arch/Kconfig bits very helpful for
things like tracehook support, without having to grovel around
Documentation for verbose design documents that I otherwise couldn't care
less about.

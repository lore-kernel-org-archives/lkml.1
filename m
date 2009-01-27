Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZA0UwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZA0UwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZA0Uvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:51:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40043 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbZA0Uvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:51:54 -0500
Date: Tue, 27 Jan 2009 18:51:37 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       srostedt@redhat.com, Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Message-ID: <20090127205137.GD15877@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	"Kok, Auke" <auke-jan.h.kok@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	powertop ml <power@bughost.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Ingo Molnar <mingo@elte.hu>, srostedt@redhat.com,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Neil Horman <nhorman@tuxdriver.com>
References: <497F69A4.2070007@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497F69A4.2070007@intel.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 27, 2009 at 12:08:04PM -0800, Kok, Auke escreveu:
> This tracer monitors regular file open() syscalls. This is a fast
> and low-overhead alternative to strace, and does not allow or
> require to be attached to every process.
> 
> The tracer only logs succesfull calls, as those are the only ones we
> are currently interested in, and we can determine the absolute path
> of these files as we log.
> 
> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

<SNIP>
 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 4d3d381..24c17d2 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -30,6 +30,7 @@ enum trace_type {
>         TRACE_USER_STACK,
>         TRACE_HW_BRANCHES,
>         TRACE_POWER,
> +       TRACE_OPEN,

Why not a TRACE_VFS or TRACE_SYSCALL and then multiplex there open,
close, etc? trace_assign_type will get humongous in no time this way.

TRACE_BLK does multiplexing, as does TRACE_PROCESS that Frank just
posted too, and I'm working on a plugin for the patch that Neil
submitted for the socket layer that also will need an entry there for
its tracepoints.

Frederic, it seems that discussion about subtypes has to continue :-)

- Arnaldo

Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbZJLSIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbZJLSIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbZJLSId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:08:33 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:61545 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449AbZJLSIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:08:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IglbSRyExU4FCrsEgmELpXK1K9DbEJ+L2h9dsJIdtuYcreRYWQA741SJYklS8q8M0y
         e5+s7goI1iLT45A0ekVNA7zBBQteIfY955sZdnrGgPnMtrjZfI+AaPabWYferrU1TvRB
         GVmREX1M+tAigzXZPCf/MITOK9BpLfPouxA2Q=
Date: Mon, 12 Oct 2009 20:07:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v4] perf: Add perf probe subcommand for
	kprobe-event setup helper
Message-ID: <20091012180751.GD5059@nowhere>
References: <4ACE56EE.8060000@redhat.com> <20091008211737.29299.14784.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008211737.29299.14784.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 05:17:38PM -0400, Masami Hiramatsu wrote:
> +#ifdef DEBUG
> +#define debug(fmt ...)	\
> +	fprintf(stderr, "DBG(" __FILE__ ":" stringify(__LINE__) "): " fmt)
> +#else
> +#define debug(fmt ...)	do {} while (0)
> +#endif



We have that too:

int eprintf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));



> +#define ERR_IF(cnd)	\
> +	do { if (cnd) {	\
> +		fprintf(stderr, "Error (" __FILE__ ":" stringify(__LINE__) \
> +			"): " stringify(cnd) "\n");			\
> +		exit(1);						\
> +	} } while (0)


And that would be nice to have in util/debug.h but more
perhaps more as a DIE_IF()


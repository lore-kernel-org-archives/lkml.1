Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbZJLSEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbZJLSEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbZJLSEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:04:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:22741 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbZJLSEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YrzOZUlBlfORQzVA8a0R7kC+/U6JwL4mm3UioatF6JSjQDjHzWp61kIuAHgWibXK2t
         3Q9p4Yx/q0GdkP8+x6pADteEE7M5CbzzJnG5xqdFBW7yfubBi2LVUgi3iLpKbswk9r3N
         +r9/vwSow7A3LJnbXPFK3+gwx6p5qrzQKgFeE=
Date: Mon, 12 Oct 2009 20:03:01 +0200
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
Message-ID: <20091012180300.GC5059@nowhere>
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
> +static void semantic_error(const char *msg)
> +{
> +	fprintf(stderr, "Semantic error: %s\n", msg);
> +	exit(1);
> +}
> +
> +static void perror_exit(const char *msg)
> +{
> +	perror(msg);
> +	exit(1);
> +}



We have that already btw:

tools/perf/util/util.h:
	extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));


> +static void msg_exit(int ret, const char *fmt, ...)
> +{
> +	va_list ap;
> +
> +	va_start(ap, fmt);
> +	fprintf(stderr, "Error:  ");
> +	vfprintf(stderr, fmt, ap);
> +	va_end(ap);
> +
> +	fprintf(stderr, "\n");
> +	exit(ret);
> +}


And somehow ditto :)


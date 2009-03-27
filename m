Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbZC0OiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbZC0OiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbZC0OiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:38:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44337 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985AbZC0OiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:38:05 -0400
Date: Fri, 27 Mar 2009 15:34:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, juan.villacis@intel.com, ak@linux.jf.intel.com
Subject: Re: [patch 3/14] x86, ptrace, bts: stop bts tracing early in
	do_exit
Message-ID: <20090327143435.GD14504@redhat.com>
References: <20090327095525.A11052@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327095525.A11052@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27, Markus Metzger wrote:
>
> +static void ptrace_bts_exit(void)
> +{
> +	if (unlikely(!list_empty(&current->ptraced)))
> +		ptrace_bts_exit_tracer();
> +
> +	if (unlikely(current->bts))
> +		ptrace_bts_exit_tracee();
> +}

Could you explain why do we need ptrace_bts_exit_tracee() ?

If current is traced, the tracer should do ptrace_bts_release()
eventually, no?

And if we really need to do ptrace_bts_exit_tracee(), then
"if (unlikely(current->bts))" check is racy. The tracer
can do PTRACE_BTS_CONFIG right after the check.

Oleg.


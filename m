Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbZGJGrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbZGJGrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 02:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbZGJGqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 02:46:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56408 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZGJGqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 02:46:52 -0400
Message-ID: <4A56E3D8.3010806@cn.fujitsu.com>
Date: Fri, 10 Jul 2009 14:46:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH -tip -v11 11/11] tracing: Add kprobes event profiling
 interface
References: <20090709202220.13223.97114.stgit@localhost.localdomain> <20090709202327.13223.16418.stgit@localhost.localdomain>
In-Reply-To: <20090709202327.13223.16418.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +Event Profiling
> +---------------
> + You can check the total number of probe hits and probe miss-hits via
> +/sys/kernel/debug/tracing/kprobe_profile.
> + The fist column is event name, the second is the number of probe hits,

s/fist/first

> +the third is the number of probe miss-hits.
> +
> +
...
> +/* Probes profiling interfaces */
> +static int profile_seq_show(struct seq_file *m, void *v)
> +{
> +	struct trace_probe *tp = v;
> +
> +	if (tp == NULL)
> +		return 0;
> +

tp will never be NULL, which is guaranteed by seq_file

> +	seq_printf(m, "%s", tp->call.name);
> +
> +	seq_printf(m, "\t%8lu %8lu\n", tp->nhits,
> +		   probe_is_return(tp) ? tp->rp.kp.nmissed : tp->kp.nmissed);
> +
> +	return 0;
> +}

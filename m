Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbYAZJLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbYAZJLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 04:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYAZJLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 04:11:37 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40404 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752969AbYAZJLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 04:11:35 -0500
Date: Sat, 26 Jan 2008 10:11:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 23/23 -v6] Critical latency timings histogram
Message-ID: <20080126091147.GB1794@elf.ucw.cz>
References: <20080126042152.526086719@goodmis.org> <20080126042804.824377395@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126042804.824377395@goodmis.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static void *l_start(struct seq_file *m, loff_t *pos)
> +{
> +	loff_t *index_ptr = kmalloc(sizeof(loff_t), GFP_KERNEL);
> +	loff_t index = *pos;
> +	struct hist_data *my_hist = m->private;
> +
> +	if (!index_ptr)
> +		return NULL;
> +
> +	if (index == 0) {
> +		atomic_dec(&my_hist->hist_mode);
> +		seq_printf(m, "#Minimum latency: %lu microseconds.\n"
> +			   "#Average latency: %lu microseconds.\n"
> +			   "#Maximum latency: %lu microseconds.\n"
> +			   "#Total samples: %llu\n"
> +			   "#There are %llu samples greater or equal"
> +			   " than %d microseconds\n"
> +			   "#usecs\t%16s\n"
> +			   , my_hist->min_lat
> +			   , my_hist->avg_lat
> +			   , my_hist->max_lat
> +			   , my_hist->total_samples
> +			   , my_hist->beyond_hist_bound_samples
> +			   , MAX_ENTRY_NUM, "samples");
> +	}

Ok, so you are adding new userland interface; I guess you should also
document it in Documentation/?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

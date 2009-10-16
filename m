Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbZJPHLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbZJPHLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 03:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZJPHLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 03:11:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54072 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbZJPHLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 03:11:41 -0400
Date: Fri, 16 Oct 2009 09:10:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf tools: Add a new generic section in perf.data
Message-ID: <20091016071046.GD20388@elte.hu>
References: <1255641017-13958-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255641017-13958-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> +/*
> + * Version 0: contains trace_info section only
> + */
> +struct perf_file_additionals {
> +	u64				version;
> +	struct perf_file_section	trace_info;
> +};

i dont disagree with the change - but it would be even nicer to simply 
define a features bitmask, instead of a flat version - and add the 
trace_info section as a feature.

That way it's all a lot more manageable: we dont know about versions per 
se, we know about features. Individual features could be developed (and 
backported) in a distributed way - without having to worry about a flat 
version model.

So i'd suggest something like a bitmask in the perf.data file header:

	DECLARE_BITMAP(features, 256);

Plus every perf version knows about the features it supports:

	DECLARE_BITMAP(features_supported, 256);

The compatibility rule is: perf only touches attributes that belong to 
features it knows about.

	Ingo

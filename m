Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZDMXBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZDMXBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbZDMXB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:01:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34293 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbZDMXB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:01:26 -0400
Date: Tue, 14 Apr 2009 01:01:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
Message-ID: <20090413230110.GB817@elte.hu>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239662166-13208-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

>  	TP_STRUCT__entry(
> -		__field(const char *, name)
> +		__array(char, name, LOCK_NAME_SIZE)
>  		__field(unsigned long, wait_usec)
>  		__field(unsigned long, wait_nsec_rem)
>  	),

Hm. These constants tend to grow - 25 will certainly be too narrow. 
But increasing it increases the record size as well.

I think we'll need an embedded __string() type, with a length field 
(but still also zero-delimited, for convenience), hm?

	Ingo

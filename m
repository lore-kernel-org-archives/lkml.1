Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbZEGIXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbZEGIXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbZEGIXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:23:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40308 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757343AbZEGIXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:23:22 -0400
Date: Thu, 7 May 2009 10:23:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/7] ring-buffer: remove unneeded conditional in
	rb_reserve_next
Message-ID: <20090507082303.GE12285@elte.hu>
References: <20090507031335.815354104@goodmis.org> <20090507031433.562803300@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507031433.562803300@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> The code in __rb_reserve_next checks on page overflow if it is the
> original commiter and then resets the page back to the original
> setting.  Although this is fine, and the code is correct, it is
> a bit fragil. Some experimental work I did breaks it easily.

s/fragil/fragile

> The better and more robust solution is to have all commiters that
> overflow the page, simply subtract what they added.
> 
> [ Impact: more robust ring buffer account management ]

it's a bit faster too (eliminates two branches) - so a 
micro-optimization as well.

	Ingo

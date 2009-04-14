Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbZDNTOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbZDNTOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 15:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZDNTNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 15:13:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35065 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZDNTNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 15:13:53 -0400
Subject: Re: [PATCH 3/8] tracing: make trace_seq operations available for
 core kernel
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
In-Reply-To: <20090414172640.993528505@goodmis.org>
References: <20090414172337.280621613@goodmis.org>
	 <20090414172640.993528505@goodmis.org>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 21:12:07 +0200
Message-Id: <1239736327.22720.239.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 13:23 -0400, Steven Rostedt wrote:
> +struct trace_seq {
> +       unsigned char           buffer[PAGE_SIZE];
> +       unsigned int            len;
> +       unsigned int            readpos;
> +};

Would not PAGE_SIZE-2*sizeof(int) be enough? That would make the struct
fit into a single page and avoid an order-1 allocation.


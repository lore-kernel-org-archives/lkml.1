Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087Ab0ATNpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0ATNpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466Ab0ATNpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:45:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:48974 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab0ATNpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:45:42 -0500
Subject: Re: [PATCH] perf tools: fix write_event()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <1263994901.4283.1060.camel@laptop>
References: <4B570657.5090105@cn.fujitsu.com>
	 <1263994901.4283.1060.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 14:44:56 +0100
Message-ID: <1263995096.4283.1062.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 14:41 +0100, Peter Zijlstra wrote:
> On Wed, 2010-01-20 at 21:34 +0800, Xiao Guangrong wrote:
> > We parse the event while it's read from mmap buffer in
> > write_event(), but sometimes the event will straddles the
> > mmap boundary, we should handle this case
> > 
> > And if we record events(such as perf kmem/sched) for long
> > times, Ctrl + C can't interrupt it just for this reason
> 
> Uhm, how why? it didn't used to know about events and just copied the
> data.

looks like acme wrecked it in f5a2c3dc.. anyway the fix is wrong, record
should not know or care about the actual events and simply write data
out.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723Ab0ATOKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab0ATOKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 09:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232Ab0ATOKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 09:10:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab0ATOKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 09:10:02 -0500
Date: Wed, 20 Jan 2010 12:09:42 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: fix write_event()
Message-ID: <20100120140942.GP14636@ghostprotocols.net>
References: <4B570657.5090105@cn.fujitsu.com>
 <1263994901.4283.1060.camel@laptop>
 <1263995096.4283.1062.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263995096.4283.1062.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 20, 2010 at 02:44:56PM +0100, Peter Zijlstra escreveu:
> On Wed, 2010-01-20 at 14:41 +0100, Peter Zijlstra wrote:
> > On Wed, 2010-01-20 at 21:34 +0800, Xiao Guangrong wrote:
> > > We parse the event while it's read from mmap buffer in
> > > write_event(), but sometimes the event will straddles the
> > > mmap boundary, we should handle this case
> > > 
> > > And if we record events(such as perf kmem/sched) for long
> > > times, Ctrl + C can't interrupt it just for this reason
> > 
> > Uhm, how why? it didn't used to know about events and just copied the
> > data.
> 
> looks like acme wrecked it in f5a2c3dc.. anyway the fix is wrong, record
> should not know or care about the actual events and simply write data
> out.

Oh well, I guess then we should do that after record finishes,
reprocessing all the data in the file.

- Arnaldo

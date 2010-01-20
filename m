Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475Ab0ATPbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0ATPbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250Ab0ATPbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:31:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:59967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab0ATPbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:31:20 -0500
Date: Wed, 20 Jan 2010 13:30:55 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: fix write_event()
Message-ID: <20100120153055.GR14636@ghostprotocols.net>
References: <4B570657.5090105@cn.fujitsu.com>
 <1263994901.4283.1060.camel@laptop>
 <1263995096.4283.1062.camel@laptop>
 <20100120140942.GP14636@ghostprotocols.net>
 <1263996897.4283.1065.camel@laptop>
 <1263998610.4283.1076.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263998610.4283.1076.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 20, 2010 at 03:43:30PM +0100, Peter Zijlstra escreveu:
> On Wed, 2010-01-20 at 15:14 +0100, Peter Zijlstra wrote:
> 
> > > > > Uhm, how why? it didn't used to know about events and just copied the
> > > > > data.
> > > > 
> > > > looks like acme wrecked it in f5a2c3dc.. anyway the fix is wrong, record
> > > > should not know or care about the actual events and simply write data
> > > > out.
> > > 
> > > Oh well, I guess then we should do that after record finishes,
> > > reprocessing all the data in the file.
> > 
> > Why do we need it at all?
> 
> To clarify, we want to keep the record cycle as small/fast as possible
> in order to minimize permutation of the system we're recording.

This is understood, its the whole reason for us to just record the
build-ids and not try and go reading all the symtabs that appeared on
perf.data.

nstead we just record 20 byte cookies that later will be looked up
somewhere, be it the cache that perf record creates or -debuginfo
packages, or the binary on the fs, whatever matches the buildid and thus
guarantees that we're not doing bogus symbol lookups.

I.e. always trying to defer everything that is possible to post
processing time, at perf report.

- Arnaldo

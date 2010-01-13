Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269Ab0AMOSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0AMOSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850Ab0AMOSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:18:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:58475 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab0AMOSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:18:21 -0500
Subject: Re: [PATCH 1/3] rbtree: Introduce rb_for_each_entry
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20100113141344.GG2934@ghostprotocols.net>
References: <1263387673-15231-1-git-send-email-acme@infradead.org>
	 <1263388569.4244.215.camel@laptop> <20100113133442.GB5036@nowhere>
	 <20100113135205.GC5576@ghostprotocols.net>
	 <1263391133.4244.226.camel@laptop>
	 <20100113141344.GG2934@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 15:18:16 +0100
Message-ID: <1263392296.4244.228.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 12:13 -0200, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 13, 2010 at 02:58:53PM +0100, Peter Zijlstra escreveu:
> > On Wed, 2010-01-13 at 11:52 -0200, Arnaldo Carvalho de Melo wrote:
> > > Em Wed, Jan 13, 2010 at 02:34:45PM +0100, Frederic Weisbecker escreveu:
> > > > At least it matches many patterns in perf :)
> > > 
> > > What an insane piece of... software! 8-) Whatever, if it makes Peter
> > > happy we can keep it on tools/perf/util/include/linux/rbtree.h, just
> > > after the:
> > > 
> > > #include "../../../../include/linux/rbtree.h"
> > > 
> > > ;-)
> > > 
> > > Just like we have list_del_range() in tools/perf/util/include/linux/list.h.
> > 
> > That's not the point, doing a for_each on the rb-trees as we have today
> > is a O(n log(n)) operation, not something you should want to do often.
> > 
> > Adding a helper promotes the idea that its a sane thing to do, its not.
> > 
> > If you really need it, open coding it isn't hard, but the lack of helper
> > does make you think and hopefully realize you're doing something funny.
> 
> We need it in several places in the perf tools, to present sorted results, to
> dump the maps for debugging purposes, etc.
> 
> But I'll go and look at each one of them to see if there is any where it
> is used in some stupid way.

Sure, but again, that's missing the point, adding that helper isn't a
good thing. We have no 64bit division operators in Linux either, for the
very same reason.


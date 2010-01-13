Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246Ab0AMN7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0AMN7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847Ab0AMN7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:59:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45574 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab0AMN7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:59:04 -0500
Subject: Re: [PATCH 1/3] rbtree: Introduce rb_for_each_entry
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20100113135205.GC5576@ghostprotocols.net>
References: <1263387673-15231-1-git-send-email-acme@infradead.org>
	 <1263388569.4244.215.camel@laptop> <20100113133442.GB5036@nowhere>
	 <20100113135205.GC5576@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 14:58:53 +0100
Message-ID: <1263391133.4244.226.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 11:52 -0200, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 13, 2010 at 02:34:45PM +0100, Frederic Weisbecker escreveu:
> > On Wed, Jan 13, 2010 at 02:16:09PM +0100, Peter Zijlstra wrote:
> > > On Wed, 2010-01-13 at 11:01 -0200, Arnaldo Carvalho de Melo wrote:
> > > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > > 
> > > > Similar to list_for_each_entry, helps reducing boilerplate in many
> > > > places and makes rbtrees closer to list.h macros.
> > > > 
> > > > First conversion will be in the tools/perf.
> > > 
> > > I'm still not sure you really want to do this, it might give people the
> > > impression its a sane thing to do ;-)
> > 
> > At least it matches many patterns in perf :)
> 
> What an insane piece of... software! 8-) Whatever, if it makes Peter
> happy we can keep it on tools/perf/util/include/linux/rbtree.h, just
> after the:
> 
> #include "../../../../include/linux/rbtree.h"
> 
> ;-)
> 
> Just like we have list_del_range() in tools/perf/util/include/linux/list.h.

That's not the point, doing a for_each on the rb-trees as we have today
is a O(n log(n)) operation, not something you should want to do often.

Adding a helper promotes the idea that its a sane thing to do, its not.

If you really need it, open coding it isn't hard, but the lack of helper
does make you think and hopefully realize you're doing something funny.




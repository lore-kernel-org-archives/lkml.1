Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901Ab0AYO6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0AYO6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115Ab0AYO57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:57:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:51027 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab0AYO56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:57:58 -0500
Date: Mon, 25 Jan 2010 12:57:45 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 12/12] Revert "perf record: Intercept all events"
Message-ID: <20100125145745.GE24418@ghostprotocols.net>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1264167553-6510-13-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20100125022351.GD24418@ghostprotocols.net>
 <a6b9f31a1001250647k7273ab80j771d673595d3ad80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6b9f31a1001250647k7273ab80j771d673595d3ad80@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 25, 2010 at 11:47:40PM +0900, Hitoshi Mitake escreveu:
> On Mon, Jan 25, 2010 at 11:23, Arnaldo Carvalho de Melo
> <acme@infradead.org> wrote:
> > Em Fri, Jan 22, 2010 at 10:39:13PM +0900, Hitoshi Mitake escreveu:
> >> This reverts commit f5a2c3dce03621b55f84496f58adc2d1a87ca16f.
> >>
> >> This patch is required for making "perf lock rec" work.
> >> The commit f5a2c3dce0 changes write_event() of builtin-record.c .
> >> And changed write_event() sometimes doesn't stop with perf lock rec.
> >>
> >> I'm researching what makes write_event() loop infinity,
> >> and noticed that there are some events with event_t->header.size == 0.
> >> But the detail of the problem,
> >> like kind of these events, isn't clear...
> >>
> >> If you know something related to this problem,
> >> could you tell me, Arnaldo?
> >
> > Well, this will have to wait for somebody to remove the need for
> > intercepting those events, reverting this patch fixes your tool while
> > breaking others that then won't catch all the events.
> 
> Yes, this patch is too egoistic thing and temporary solution.
> I have to consider and modify 'perf lock'.

Hey, don't get me wrong, the situation is fragile, either way something
will get broken and that isn't your fault, its just that we need some
sensible and non racy way to inject the buildids at 'perf record' time.

The way I did it, long ago, intercepting events in 'perf record' to
build a DSO list to then at 'perf record' exit to insert a table at the
perf.data file header looks too intrusive now, so we need some other way
that doesn't have this problem and its not racy.
 
> > I'll get 'perf regtest' out with some initial tests then try to get some
> > proposal for injecting the buildid, if found in a DSO, via
> > PERF_RECORD_MMAP, lets see how this goes...
> 
> What does "DSO" mean? Sorry, I'm not good at English...

As Peter said, anything that that is on an executable MMAP.
 
> >
> > Best Regards,
> >
> > - Arnaldo
> >
> > BTW: I took longer to send a response to this question addressed to me
> > because I wasn't on the CC list :-)
> 
> Oh, sorry... I wonder why I didn't add you to Cc or To :(
> It is completely my mistake, and thanks for your reply!

:-) Best Regards,

- Arnaldo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab0BDAD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:03:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39476 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0BDAD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:03:28 -0500
Subject: Re: [RFC][PATCH] perf_events, x86: PEBS support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jamie Iles <jamie.iles@picochip.com>, Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, perfmon2-devel@lists.sf.net
In-Reply-To: <bd4cb8901002031551h3f1edb2bj706c768344fcd93f@mail.gmail.com>
References: <1265129772.24455.329.camel@laptop>
	 <20100202182653.GB19320@elte.hu> <1265135588.24455.350.camel@laptop>
	 <bd4cb8901002030522s6306fdf4qbf4eb48c0674d980@mail.gmail.com>
	 <1265205361.24455.533.camel@laptop>
	 <bd4cb8901002030607y519c191av733231ba2aec2e9c@mail.gmail.com>
	 <1265206784.24455.568.camel@laptop>
	 <bd4cb8901002030630naaa83c1j397759750007ae4c@mail.gmail.com>
	 <1265208012.24455.592.camel@laptop> <1265241010.24455.1627.camel@laptop>
	 <bd4cb8901002031551h3f1edb2bj706c768344fcd93f@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 01:03:13 +0100
Message-ID: <1265241793.24455.1647.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 00:51 +0100, Stephane Eranian wrote:
> On Thu, Feb 4, 2010 at 12:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2010-02-03 at 15:40 +0100, Peter Zijlstra wrote:
> >>
> >> If only they would reset the counter on overflow instead of on record,
> >> that would solve quite a few issues I imagine.
> >
> > So I tried enabling the regular PMC overflow interrupt and reprogramming
> > the counter from that, but touching the counter seems to destroy the
> > PEBS assist, so much for that idea.
> >
> Yes, you have to leave the INT bit off, otherwise you get an
> interrupt for each overflow, thus you lose the buffer advantage.

Well sure, but that's not the point. I was thinking that if we need to
do single event pebs anyway, we might as well try to reprogram on the
PMC overflow interrupt instead of on the PEBS overflow and curb some of
that drift.

Also, it makes keeping the event count value a lot easier. But alas.


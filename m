Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0BCOmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 09:42:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43961 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab0BCOmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 09:42:18 -0500
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
In-Reply-To: <bd4cb8901002030630naaa83c1j397759750007ae4c@mail.gmail.com>
References: <1265129772.24455.329.camel@laptop>
	 <20100202182653.GB19320@elte.hu> <1265135588.24455.350.camel@laptop>
	 <bd4cb8901002030522s6306fdf4qbf4eb48c0674d980@mail.gmail.com>
	 <1265205361.24455.533.camel@laptop>
	 <bd4cb8901002030607y519c191av733231ba2aec2e9c@mail.gmail.com>
	 <1265206784.24455.568.camel@laptop>
	 <bd4cb8901002030630naaa83c1j397759750007ae4c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 15:40:12 +0100
Message-ID: <1265208012.24455.592.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 15:30 +0100, Stephane Eranian wrote:
> On Wed, Feb 3, 2010 at 3:19 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2010-02-03 at 15:07 +0100, Stephane Eranian wrote:
> >> >> The only improvement that PEBS provides is that you get an IP and the
> >> >> machine state at retirement of an instruction that caused the event to
> >> >> increment. Thus, the IP points to the next dynamic instruction. The instruction
> >> >> is not the one that cause the P-th occurence of the event, if you set the
> >> >> period to P. It is at P+N, where N cannot be predicted and varies depending
> >> >> on the event and executed code. This introduces some bias in the samples..
> >> >
> >> > I'm not sure I follow, it records the next event after overflow, doesn't
> >> > that make it P+1?
> >> >
> >> That is not what I wrote. I did not say if records at P+1. I said it records
> >> at P+N, where N varies from sample to sample and cannot be predicted.
> >> N is expressed in the unit of the sampling event.
> >
> > OK, so I'm confused.
> >
> > The manual says it arms the PEBS assist on overflow, and the PEBS thing
> > will then record the next event. Which to me reads like P+1.
> >
> you are assuming arming is instantaneous.

Yes I was, ok that stinks.

If only they would reset the counter on overflow instead of on record,
that would solve quite a few issues I imagine.

Then add IP to the actual instruction and you've got yourself a useful
tool :-)


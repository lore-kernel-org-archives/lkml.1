Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab0BCXvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:51:40 -0500
Received: from smtp-out.google.com ([216.239.33.17]:52379 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab0BCXvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:51:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=t2L4mzCxgnwrSSTarV/ne9LhyGkocWJZjUBfM516m3o7zMMDDb93OplcZjoYe+jBl
	Kj6i1ZzsWCBI7DBxIdeFQ==
MIME-Version: 1.0
In-Reply-To: <1265241010.24455.1627.camel@laptop>
References: <1265129772.24455.329.camel@laptop>
	 <20100202182653.GB19320@elte.hu> <1265135588.24455.350.camel@laptop>
	 <bd4cb8901002030522s6306fdf4qbf4eb48c0674d980@mail.gmail.com>
	 <1265205361.24455.533.camel@laptop>
	 <bd4cb8901002030607y519c191av733231ba2aec2e9c@mail.gmail.com>
	 <1265206784.24455.568.camel@laptop>
	 <bd4cb8901002030630naaa83c1j397759750007ae4c@mail.gmail.com>
	 <1265208012.24455.592.camel@laptop>
	 <1265241010.24455.1627.camel@laptop>
Date: Thu, 4 Feb 2010 00:51:30 +0100
Message-ID: <bd4cb8901002031551h3f1edb2bj706c768344fcd93f@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf_events, x86: PEBS support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jamie Iles <jamie.iles@picochip.com>, Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 12:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-02-03 at 15:40 +0100, Peter Zijlstra wrote:
>>
>> If only they would reset the counter on overflow instead of on record,
>> that would solve quite a few issues I imagine.
>
> So I tried enabling the regular PMC overflow interrupt and reprogramming
> the counter from that, but touching the counter seems to destroy the
> PEBS assist, so much for that idea.
>
Yes, you have to leave the INT bit off, otherwise you get an
interrupt for each overflow, thus you lose the buffer advantage.

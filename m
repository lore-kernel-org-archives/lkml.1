Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab0BCOaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 09:30:12 -0500
Received: from smtp-out.google.com ([216.239.44.51]:60961 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab0BCOaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 09:30:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=IX+QCEgD2ofwXBBBgbjkd73CW+NsbbcVYY+VezG1XGvyexTDUicbsj2wZGMJj2L8o
	S3Asal1QeNMJXBoehfszg==
MIME-Version: 1.0
In-Reply-To: <1265206784.24455.568.camel@laptop>
References: <1265129772.24455.329.camel@laptop>
	 <20100202182653.GB19320@elte.hu> <1265135588.24455.350.camel@laptop>
	 <bd4cb8901002030522s6306fdf4qbf4eb48c0674d980@mail.gmail.com>
	 <1265205361.24455.533.camel@laptop>
	 <bd4cb8901002030607y519c191av733231ba2aec2e9c@mail.gmail.com>
	 <1265206784.24455.568.camel@laptop>
Date: Wed, 3 Feb 2010 15:30:03 +0100
Message-ID: <bd4cb8901002030630naaa83c1j397759750007ae4c@mail.gmail.com>
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

On Wed, Feb 3, 2010 at 3:19 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-02-03 at 15:07 +0100, Stephane Eranian wrote:
>> >> The only improvement that PEBS provides is that you get an IP and the
>> >> machine state at retirement of an instruction that caused the event to
>> >> increment. Thus, the IP points to the next dynamic instruction. The instruction
>> >> is not the one that cause the P-th occurence of the event, if you set the
>> >> period to P. It is at P+N, where N cannot be predicted and varies depending
>> >> on the event and executed code. This introduces some bias in the samples..
>> >
>> > I'm not sure I follow, it records the next event after overflow, doesn't
>> > that make it P+1?
>> >
>> That is not what I wrote. I did not say if records at P+1. I said it records
>> at P+N, where N varies from sample to sample and cannot be predicted.
>> N is expressed in the unit of the sampling event.
>
> OK, so I'm confused.
>
> The manual says it arms the PEBS assist on overflow, and the PEBS thing
> will then record the next event. Which to me reads like P+1.
>
you are assuming arming is instantaneous.

Return-Path: <linux-kernel-owner+w=401wt.eu-S932405AbZJEJZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbZJEJZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 05:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932390AbZJEJZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 05:25:33 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:63085 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbZJEJZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 05:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rRGpppZayGUXR5zpAEK81LpxvXlNL8GA79LnZq/UkT3kNwg/jwfnQ/56EnjEcVPF1Q
         99DqK8pUmbhYeoNKY8Ivi6RsXXml2+guhBinK2HSOe/Uoh0ZnDuRUMQVR6RYow0VMZin
         SC0eL6XUBvPgBU11faoztAQoS+O3uPP8mSoAo=
MIME-Version: 1.0
In-Reply-To: <20091005085551.GA31147@elte.hu>
References: <20090925122556.2f8bd939@infradead.org> <y0mhbuplmlr.fsf@fche.csb>
	 <20090926183246.GA4141@in.ibm.com>
	 <20090926204848.0b2b48d2@infradead.org>
	 <20091001072518.GA1502@elte.hu> <20091001081616.GA3636@in.ibm.com>
	 <20091001085330.GC15345@elte.hu> <1254729210.26976.15.camel@twins>
	 <20091005085551.GA31147@elte.hu>
Date: Mon, 5 Oct 2009 11:24:53 +0200
Message-ID: <c62985530910050224u5e755808jc2a25c3dd5c172da@mail.gmail.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to get 
	to performance counters
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/5 Ingo Molnar <mingo@elte.hu>:
>
> * Peter Zijlstra <peterz@infradead.org> wrote:
>> Non-trivial.
>>
>> Something like this would imply a single output channel for all these
>> CPUs, and we've already seen that stuffing too many CPUs down one such
>> channel (using -M) leads to significant performance issues.
>
> We could add internal per cpu buffering before it hits any globally
> visible output channel. (That has come up when i talked to Frederic
> about the function tracer.) We could even have page sized output (via
> the introduction of a NOP event that fills up to the next page edge).


That looks good for the counting/sampling fast path, but would that scale
once it comes to reordering in the globally visible output channel?
Such a union has its costs.

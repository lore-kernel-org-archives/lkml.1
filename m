Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200Ab0AUKnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0AUKnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060Ab0AUKnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:43:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:56835 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0AUKnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:43:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=NclVGvtEqmXzw6KT79UFylubL4ukBUy4s3ZPhvx9QSxfSjxXtaivpWV5jDmd9xLO4
	pLnhRKMMxC6Hr8aTir6OQ==
MIME-Version: 1.0
In-Reply-To: <1264070181.4283.1149.camel@laptop>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <1264070181.4283.1149.camel@laptop>
Date: Thu, 21 Jan 2010 11:43:02 +0100
Message-ID: <bd4cb8901001210243y16dbbf8doe66cf24d15120443@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v5)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 11:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-01-18 at 10:58 +0200, Stephane Eranian wrote:
>>  void hw_perf_enable(void)
>>  {
>
>
>> +               cpuc->n_added = 0;
>> +               perf_events_lapic_init();
>
> Just wondering, why do we need that lapic_init() there?
>
I think I picked it up from x86_pmu_enable(). I don't think
you necessarily need it here. Not clear to me why it was
in x86_pmu_enable() to begin with.

I will post a new version of the patch which fixes some bugs and
also implements true fast path (reuse of previous assignment). It turned
out, things were a bit more complicated than what I had in v5.

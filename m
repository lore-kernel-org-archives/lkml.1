Return-Path: <linux-kernel-owner+w=401wt.eu-S932533AbZJEKNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbZJEKNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932490AbZJEKNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:13:46 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:47866 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbZJEKNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:13:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wlG+jnkvsM3ydRqSH5lQIGlFLfSvYgbMXlc/PXeNGtf8ih5nbXLUhNTE/xoLw6pir4
         HRfxo1jPCOebV4ubPWHqVFB9yFFXnb8qoeCgwZZgiW1VmUQzyR5hEAqQu/wEWoj6hT9y
         ux7Z1SdDHiieqm+wO9rsUhvttntwqs2rfWIJY=
MIME-Version: 1.0
In-Reply-To: <20091005095543.GA4266@elte.hu>
References: <20090925122556.2f8bd939@infradead.org> <y0mhbuplmlr.fsf@fche.csb>
	 <20090926183246.GA4141@in.ibm.com>
	 <20090926204848.0b2b48d2@infradead.org>
	 <20091001072518.GA1502@elte.hu> <20091001081616.GA3636@in.ibm.com>
	 <20091001085330.GC15345@elte.hu> <20091004222838.GA5001@nowhere>
	 <20091005095543.GA4266@elte.hu>
Date: Mon, 5 Oct 2009 12:13:06 +0200
Message-ID: <c62985530910050313oa23c8e5vd85a9cc4ee591ee2@mail.gmail.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to get 
	to performance counters
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/5 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Can't we instead modify the perf events to be able to run on multiple
>> contexts?
>>
>> We could change struct perf_event::ctx into a list of context and then
>> attach it to several cpu contexts.
>>
>> The perf event struct have been designed to run on only one context so
>> its structure and handling does not deal with races due to concurrent
>> uses I guess. But at a first glance, few things would need to be
>> modified to handle that, and at a low cost.
>>
>> There might be bad corner cases I forget though...
>
> Dunno, i assumed it wouldnt be possible sanely. If you tried a patch we
> could argue about the particulars ...
>
> This would in essence create a new event type: system-wide. It doesnt
> scale in its naive implementation - which would be fine for low freq
> events.
>
> We could encode it via sys_perf_event_open(pid:-1, cpu:-1).
>
>        Ingo
>

We could combine the above (single-channel/per-cpu page granularity) and the
abstract of wide perf events. That will avoid creating a new type that
wrap a set of
multiple events, which would be another kind of type to handle,
breaking the genericity
and add a lot of code.

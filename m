Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690Ab0AYOrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab0AYOrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118Ab0AYOrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:47:41 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:51111 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0AYOrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:47:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=b3a5LePzzSj+rP9cHPkMKK9htpyklWyN+WGyX9KC1orccFq0SamKx8VJWZSblTlX95
         897s1AguVGNfeGuYRTYAvclOQKY5iZK+MqgJVEqo/4cYvRSWFQ1/QUnRS1A72JaMDORb
         Vw/E5Epa4jGE8y0O2PwAre00ajTBvwyE2O/sw=
MIME-Version: 1.0
In-Reply-To: <20100125022351.GD24418@ghostprotocols.net>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1264167553-6510-13-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20100125022351.GD24418@ghostprotocols.net>
Date: Mon, 25 Jan 2010 23:47:40 +0900
X-Google-Sender-Auth: d5ad6b1630b5a65a
Message-ID: <a6b9f31a1001250647k7273ab80j771d673595d3ad80@mail.gmail.com>
Subject: Re: [PATCH 12/12] Revert "perf record: Intercept all events"
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 11:23, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Fri, Jan 22, 2010 at 10:39:13PM +0900, Hitoshi Mitake escreveu:
>> This reverts commit f5a2c3dce03621b55f84496f58adc2d1a87ca16f.
>>
>> This patch is required for making "perf lock rec" work.
>> The commit f5a2c3dce0 changes write_event() of builtin-record.c .
>> And changed write_event() sometimes doesn't stop with perf lock rec.
>>
>> I'm researching what makes write_event() loop infinity,
>> and noticed that there are some events with event_t->header.size == 0.
>> But the detail of the problem,
>> like kind of these events, isn't clear...
>>
>> If you know something related to this problem,
>> could you tell me, Arnaldo?
>
> Well, this will have to wait for somebody to remove the need for
> intercepting those events, reverting this patch fixes your tool while
> breaking others that then won't catch all the events.

Yes, this patch is too egoistic thing and temporary solution.
I have to consider and modify 'perf lock'.

>
> I'll get 'perf regtest' out with some initial tests then try to get some
> proposal for injecting the buildid, if found in a DSO, via
> PERF_RECORD_MMAP, lets see how this goes...

What does "DSO" mean? Sorry, I'm not good at English...

>
> Best Regards,
>
> - Arnaldo
>
> BTW: I took longer to send a response to this question addressed to me
> because I wasn't on the CC list :-)
>
>

Oh, sorry... I wonder why I didn't add you to Cc or To :(
It is completely my mistake, and thanks for your reply!

Thanks
	Hitoshi

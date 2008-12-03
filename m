Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbYLCKHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbYLCKHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 05:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYLCKHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 05:07:07 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:13012 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbYLCKHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 05:07:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OBeE2O1KYv/9ofkqDR1g7lX4M22/Pa3NGn6YPqE4fSeBmzmunfMGykSrTtyijfA6C3
         YM1XQJCPq39FEpkJoXCgwRo7ylJwrFof+vn3NdQ2ib9c1rgnc6eCZNH0yjuCrXBIPaEy
         t9F6zAMMp0xbnsZmtZslNC2ktlXDg1M2BJWHs=
Message-ID: <c62985530812030207l75084154vf1f94fe22ab0448@mail.gmail.com>
Date: Wed, 3 Dec 2008 11:07:04 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: improve duration output
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Tim Bird" <tim.bird@am.sony.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081203083332.GA5455@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4935E19C.3090501@gmail.com> <4935E226.3060906@gmail.com>
	 <20081203081906.GH21006@elte.hu> <20081203083332.GA5455@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/3 Ingo Molnar <mingo@elte.hu>:
> small detail: i'd suggest to remove the newline before the context-switch
> box. That makes it appear visually to attach logically with the
> switch-out place, not the switch-in place:
>
>>  0)    cat-2796    |   0.579 us    |            native_load_sp0();
>>  0)    cat-2796    |   0.722 us    |            native_load_tls();
>>  ------------------------------------------
>>  | 0)    cat-2796    =>   events/-9
>>  ------------------------------------------
>>
>>  0)   events/-9    |               |    finish_task_switch() {
>>  0)   events/-9    |   0.789 us    |      _spin_unlock_irq();
>>  0)   events/-9    |   2.309 us    |    }
>>  0)   events/-9    | ! 269848.5 us |  }
>
> which is what we want to express.
>


Ok, I'll fix it.


>
> btw., i tested the graph tracer on a 16-way 64-bit box as well, and the
> multi-digit CPU field printout magic works fine there too:
>
>  9)               |    pick_next_task() {
>  9)   0.283 us    |      pick_next_task_fair();
>  9)   0.276 us    |      pick_next_task_rt();
>  9)   0.273 us    |      pick_next_task_fair();
>  9)   0.279 us    |      pick_next_task_idle();
>  9)   2.596 us    |    }
>  9)   0.566 us    |    __lock_text_start();
>  10)   0.299 us    |        }
>  10)               |        mm_init() {
>  10)               |          pgd_alloc() {
>  10)               |            __get_free_pages() {
>  10)               |              alloc_pages_current() {
>  10)   0.330 us    |                policy_zonelist();
>  10)               |                __alloc_pages_internal() {
>
>        Ingo
>

Hmm not really, there should be one space more before the 9 to fit the
log10(MAX_CPU) here and not break
the column.

Thanks!

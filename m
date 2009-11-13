Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZKMOqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZKMOqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 09:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZKMOqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 09:46:43 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:53198 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZKMOqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 09:46:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rDwRXOaCoY9XN28Fxdum+eRodypAwwyuQ381HiR78NhdxXtMbGkzJwymHJWtPusoqK
         saTy2RiyuqW+VP4MwWkN3jXHmyellfUlMnWrUYMNTWsAP/s9b5Lw7Tdjh7JrspEnqCG7
         0tV09hDjz2q4fkIW64iffYXm+S9p9I8k0J4sQ=
MIME-Version: 1.0
In-Reply-To: <1258099655.4039.998.camel@laptop>
References: <193b0f820911121403w35c57158kf3721309e1f2ebd7@mail.gmail.com> 
	<1258099655.4039.998.camel@laptop>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Fri, 13 Nov 2009 12:46:26 -0200
Message-ID: <193b0f820911130646g5e2b88d2t6a1cf6b483b5266e@mail.gmail.com>
Subject: Re: perf stat output
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 06:07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2009-11-12 at 20:03 -0200, Lucas De Marchi wrote:
>> Hi all!
>>
>> Some questions about perf stat output. See example:
>>
>>
>> lucas@LMS-linux:~/programming/testprograms> perf stat -e
>> L1-dcache-loads -e L1-dcache-load-misses -- make -j
>> gcc test_schedchanges.c -o test_schedchanges
>> gcc -pthread test_taskaff1.c -o test_taskaff1
>> gcc -pthread test_taskaff2.c -o test_taskaff2
>> gcc -pthread test_taskaff3.c -o test_taskaff3
>>
>>  Performance counter stats for 'make -j':
>>
>>        161384667  L1-dcache-loads          #      0.000 M/sec
>>               24853791  L1-dcache-load-misses    #      0.000 M/sec
>>
>>                 0.066893389  seconds time elapsed
>>
>> Why do we have both L1-dcache-loads and  L1-dcache-load-misses with
>> 0.000 M/sec? Also, why do we have 0 M/s when running "perf stat -a -e
>> cache-misses -e cache-references" but values different than 0 when
>> running "perf stat -a" without selecting the events?
>
> No idea, you'd have to look at the code computing this M/sec stuff. I
> think Ingo wrote that, so he might have an idea.

But should it be, for example, L1-dcache-loads / seconds time elapsed,
or does it have another meaning?



Lucas De Marchi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbZFVPrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbZFVPrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbZFVPrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:47:08 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:63542 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZFVPrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wyh0gpoRNhdUwGrxy3ZurA0+wEHzjV8X0ZSj0HlC10wjUiKtpA1TWQxUfejQ8c2oZX
         tPD8n+4Q0ZexUD+iDXvIEKG3NV7aU4kINLmhFJn/gquxw8ZOY8ePDMiJAg+jA4ByXd2g
         t+nRTzw7zl4PJwrRTxWW0sU65fKENp/CjZuTI=
MIME-Version: 1.0
In-Reply-To: <20090622153431.GA18466@elte.hu>
References: <4A3FB09D.9050903@gmail.com> <20090622153431.GA18466@elte.hu>
Date: Mon, 22 Jun 2009 17:47:07 +0200
Message-ID: <25e057c00906220847t15425f38maf486c291d1d2468@mail.gmail.com>
Subject: Re: [PATCH] tools: fread does not return negative on error
From: roel kluin <roel.kluin@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: git@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 5:34 PM, Ingo Molnar<mingo@elte.hu> wrote:
>
> * Roel Kluin <roel.kluin@gmail.com> wrote:
>
>> size_t res cannot be less than 0. fread returns 0 on error.
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>> Is this correct? please review.
>>
>> diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
>> index eaba093..376a337 100644
>> --- a/tools/perf/util/strbuf.c
>> +++ b/tools/perf/util/strbuf.c
>> @@ -259,7 +259,7 @@ size_t strbuf_fread(struct strbuf *sb, size_t size, FILE *f)
>>       res = fread(sb->buf + sb->len, 1, size, f);
>>       if (res > 0)
>>               strbuf_setlen(sb, sb->len + res);
>> -     else if (res < 0 && oldalloc == 0)
>> +     else if (res == 0 && oldalloc == 0)
>>               strbuf_release(sb);
>>       return res;
>
> This comes straight from Git's strbuf.c so i've Cc:-ed the Git list.
>
> Roel, did you get some compiler warning that made you look at this
> code?
>
>        Ingo
>

No, I use sed to catch these bugs.

Roel

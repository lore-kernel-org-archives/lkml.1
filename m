Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYJEBt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYJEBt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 21:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYJEBts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 21:49:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:43576 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYJEBtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 21:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=CH+WdO/o66o+DTFgBMd6Hc+HPpX2XpGr4uk7KorEW1MhKfByJgkBVyMeu2y9d8Ec/5
         BZIV2C7KEvBeUQptEpWMAA2x2HenKS+j3jusAarojV2WXeQQ7sU3BCRqWOyNh3wiMxId
         SQjpArm/olePy8OGFwhGD0FIMtsrbUGqRmqhE=
Message-ID: <86802c440810041849g421ff524pf987f6c872e1d12a@mail.gmail.com>
Date: Sat, 4 Oct 2008 18:49:46 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] x86: mtrr_cleanup: first 1M should be coverred in var mtrrs
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48E80E60.8080106@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223157033-30217-1-git-send-email-yhlu.kernel@gmail.com>
	 <1223157033-30217-2-git-send-email-yhlu.kernel@gmail.com>
	 <48E80E60.8080106@zytor.com>
X-Google-Sender-Auth: f641c7d399e2b3cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2008 at 5:46 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> +       /*
>> +        * [0, 1M) should always be coverred by var mtrr with WB
>> +        * and fixed mtrrs should take effective before var mtrr for it
>> +        */
>> +       nr_range = add_range_with_merge(range, nr_range, 0,
>> +                                       (1ULL<<(20 - PAGE_SHIFT)) - 1);
>> +       /* sort the ranges */
>> +       sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
>> +
>
> The first 1 MB is a total don't care for the variable MTRRs -- they don't
> have to be covered *or* uncovered, since the entire first 1 MB is addressed
> by fixed MTRRs.

so it is safe to put it in WB, and can be spare some regs because it
start from base 0.

>
> In practice, it is *likely* that you're going to want to merge it with a WB
> MTRR, but with various vendors doing all kinds of strange things on
> EFI-damaged platforms, it may not always be that way.

EFI will not use fixed-mtrr for first 1M? and not cover first 1M in
var mtrr with WB? that will run out mtrr regs..

YH

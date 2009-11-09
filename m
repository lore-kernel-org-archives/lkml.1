Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbZKIUVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbZKIUVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbZKIUVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:21:44 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:58335 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZKIUVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:21:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GM5Hwi/pRRqDfb1bTdVN49FKXm/ysUeJEq/JZlr9FvJrqZwIQWfFXFU0/fKLlA/bbz
         UlVheaULzw4pvEJ7Tg+zLwUjOznUFECTQKb8nVv8LYVnIDe5U+ZY6mAu8dxzUkCpM85r
         MGDrvoQ1ijcakHgUxYqlCJiwIyYz4JUGvWI4A=
MIME-Version: 1.0
In-Reply-To: <84144f020911091213j393a9761pe13808d1e091e169@mail.gmail.com>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <84144f020911091213j393a9761pe13808d1e091e169@mail.gmail.com>
Date: Mon, 9 Nov 2009 22:21:48 +0200
X-Google-Sender-Auth: d3e4baa0ca559151
Message-ID: <84144f020911091221n1d025d9bv3915751bf474b47a@mail.gmail.com>
Subject: Re: [PATCH 07/10] bootmem: add free_bootmem_late
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 9, 2009 at 10:13 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>        for (cursor = start; cursor < end; cursor += BITS_PER_LONG) {
>> -               unsigned long idx, vec;
>> +               unsigned long vec;
>>
>> -               idx = cursor - start;
>> -               vec = ~map[idx / BITS_PER_LONG];
>> +               if (map) {
>> +                       unsigned long idx = cursor - start;
>> +                       vec = ~map[idx / BITS_PER_LONG];
>> +               } else {
>> +                       if (end - cursor >= BITS_PER_LONG)
>> +                               vec = ~0UL;
>
> Why do we need the above?

OK, I figured that out. I'm not sure why you want to play tricks with
"vec" when you could just add a new helper that calls
__free_pages_bootmem() for the full contiguous page range.

                                Pekka

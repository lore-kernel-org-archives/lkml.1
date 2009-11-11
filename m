Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbZKKP2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbZKKP2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbZKKP2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:28:21 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:48368 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbZKKP2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:28:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xfk3fG7+67UOS8jjzlWBMR8dwWEfGofYNTJp2edFLjaAyGiowmSoE0U8d7qe8/uNn3
         tTAYpC7C2h3nuZ4pUkStR6VtDjbiBynXK/5jOHWTl3nfCba3+jfpV0gBeGYk2yFnjN30
         KZDONS22trCqi/mQPcBDvqbnOh3HMR43eCRqo=
MIME-Version: 1.0
In-Reply-To: <a4c8a6d00911110709j65b54875sb9e56edf0a32c28d@mail.gmail.com>
References: <cover.1257864802.git.andre.goddard@gmail.com>
	 <2bd27b061789ed14dd80816fd987273ae33ffbd1.1257864802.git.andre.goddard@gmail.com>
	 <a4c8a6d00911110709j65b54875sb9e56edf0a32c28d@mail.gmail.com>
Date: Wed, 11 Nov 2009 13:28:25 -0200
Message-ID: <a4c8a6d00911110728o14061ee3y11921ed19cf876e8@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] bsearch: prevent overflow when computing middle 
	comparison element
From: Thiago Farina <tfransosi@gmail.com>
To: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>
Cc: tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 1:09 PM, Thiago Farina <tfransosi@gmail.com> wrote:
> On Tue, Nov 10, 2009 at 1:00 PM, André Goddard Rosa
> <andre.goddard@gmail.com> wrote:
>>  void *bsearch(const void *key, const void *base, size_t num, size_t size,
>>              int (*cmp)(const void *key, const void *elt))
>>  {
>> -       int start = 0, end = num, mid, result;
>> +       size_t start = 0, end = num;
>> +       int result;
>>
>>        while (start < end) {
>> -               mid = (start + end) / 2;
>> +               size_t mid = start + (end - start) / 2;
> I think it is more readable if you could keep the mid variable outside
> of the while loop.
>
I mean: size_t start = 0, end = num, mid;

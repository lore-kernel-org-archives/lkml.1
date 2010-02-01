Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0BAWsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:48:22 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:61421 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab0BAWsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:48:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I3jCqdlbDyZ/p+Gg0WYebdCaujLhFH0dOJoHs95w/af/BVYwTC7yDHDOz63gEGrlwa
         TO2bRnB2XonLUn1sl1e8Y+4cj2lVVPDyfSrJSUFm9O77rN/AWUHNZtcRGVTtX0J1JLm/
         2BAVf/ESNzx4gAt664bT9cC3nLitagXnOGkR4=
MIME-Version: 1.0
In-Reply-To: <201002020819.55499.rusty@rustcorp.com.au>
References: <817ecb6f1002010829m712ffff4hfb64ff3ea236e1f1@mail.gmail.com>
	 <201002020819.55499.rusty@rustcorp.com.au>
Date: Mon, 1 Feb 2010 17:48:16 -0500
Message-ID: <817ecb6f1002011448l7a9d5de4m47bd37f5e8503877@mail.gmail.com>
Subject: Re: [PATCH V9] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But not compile tested:
[...]
> The casts here should cause a warning.

I did compile it prior to submission and the resulting kernel boots.
However, you are right about the warnings as they scrolled off the
screen when I did not pay attention.
Will fix.

>> +     if (total_size > text_size) {
>> +             begin_pfn = PFN_UP((unsigned long)base + text_size);
>> +             end_pfn = PFN_UP((unsigned long)base + total_size);
>> +             if (end_pfn > begin_pfn)
>> +                     set_memory_nx(begin_pfn << PAGE_SHIFT,
>> +                                             end_pfn - begin_pfn);
>
> Use the helper here too?

No, not really. The helper uses PFN_DUWN, and we need PFN_UP here.
This is the only place where I use PFN_UP, so another helper would not
make much sense.

Thanks.

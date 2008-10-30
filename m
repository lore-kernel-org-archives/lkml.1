Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYJ3Gks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYJ3Gks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 02:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYJ3Gkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 02:40:40 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:49503 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbYJ3Gkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 02:40:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OXIp1WcdrjSJVLPBhPoi4tLlnRETtDfgeeEZs6JR2B0Nik6ilakLnZ48uA8IUcAyJa
         unVjFP5mXNy5rnYHI/rS5ALdaEEDfgCQC0iMF4hjCsOvroAwcGbjxA42JqCYDQH/+Hba
         LxeljmuA/2sJEsqrenZa3hwbF63TvwAUvpzdg=
Message-ID: <df9815e70810292340g52d38e83t47dffd02125b4fe3@mail.gmail.com>
Date: Thu, 30 Oct 2008 14:40:37 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix inline assembly constraints
Cc: "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <49093012.7010301@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225297937-2917-1-git-send-email-albcamus@gmail.com>
	 <20081029163400.GA14866@elte.hu>
	 <df9815e70810291931i4c00966u8f4493386e376b28@mail.gmail.com>
	 <49093012.7010301@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 11:54 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Jike Song wrote:
>>
>> Besides, by looking at the inline assembly in kernel,  I found lots of
>> codes like this:
>>
>>         static inline void atomic_add(int i, atomic_t *v)
>>         {
>>               asm volatile(LOCK_PREFIX "addl %1,%0"
>>                            : "=m" (v->counter)
>>                            : "ir" (i), "m" (v->counter));
>>         }
>>
>>
>> Yes, it works. But a little ugly..  Should this be cleaned-up with the
>> following?
>>
>>         : "+m" (v->counter)
>>         : "ir" (i)
>>
>> If you agrees, I'll send out the patch; otherwise I won't wasting your time ;-)
>>
>
> Please don't change them just to change them, if there is no actual
> error.  You never know when you're going to trigger a new bug in some
> weird version of gcc.
>
>        -hpa

Yes, sometimes gcc did have bugs with its obscure inline asm
conventions. But I think the change of x86-64 atomic operations should
be OK. Anyway, the "+" constraint is more clear than a "=m" output and
 a "m" input.

The 32-bit atomic ops were already changed to "+m".(commit
b862f3b099f3ea672c7438c0b282ce8201d39dfc)

-- 
Thanks,
Jike

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbYJ3Cbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbYJ3Cbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 22:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYJ3Cbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 22:31:33 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:18899 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYJ3Cbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 22:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ul4OyQJEit/D2DjIgtE5n6nMsJaMsGDy8imFPTgjAwRC856xm0ABBpnEcXgHnE6u3W
         trYxtGErwhv9vBbIEa5Z/KKwpEGYqYUOY0PbEV/r4yiIenQ7Y8wrtvRkbP6ZlvlAUolW
         WdyC8fhusGlU1JCYbot2GwBRKSXUJwzZ08siY=
Message-ID: <df9815e70810291931i4c00966u8f4493386e376b28@mail.gmail.com>
Date: Thu, 30 Oct 2008 10:31:30 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix inline assembly constraints
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081029163400.GA14866@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225297937-2917-1-git-send-email-albcamus@gmail.com>
	 <20081029163400.GA14866@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 12:34 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jike Song <albcamus@gmail.com> wrote:
>>
>> --
>
> that was an easy patch to act upon ;-)
>
>        Ingo
>
Sorry Ingo, I missed your point. Do you mean this patch is trivial or
unnecessary?

Besides, by looking at the inline assembly in kernel,  I found lots of
codes like this:

        static inline void atomic_add(int i, atomic_t *v)
        {
	        asm volatile(LOCK_PREFIX "addl %1,%0"
		             : "=m" (v->counter)
		             : "ir" (i), "m" (v->counter));
        }


Yes, it works. But a little ugly..  Should this be cleaned-up with the
following?

        : "+m" (v->counter)
        : "ir" (i)

If you agrees, I'll send out the patch; otherwise I won't wasting your time ;-)


-- 
Thanks,
Jike

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZEMA2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZEMA2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZEMA2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:28:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:32075 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbZEMA2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eFjIDI+Mdl7o73QxUkeyOW/hxMuO0vL0/SdsqxjSAUzEG7V3AhpqgGLanHcw3azppN
         kZ2pe+IBCRIGUbrVlvlvCBGEOKEj7E5Lt1/XfJvoQtSbzrIJEFXirAkwB8kNPK7PDur8
         qIHy/W7hio4smqjSy5Blbtbfujr7qk0rtFHVA=
MIME-Version: 1.0
In-Reply-To: <20090512191848.25764af6@gondolin>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com>
	 <20090512154456.GC6255@nowhere> <20090512160434.GD6255@nowhere>
	 <20090512183105.09e628f0@gondolin> <20090512165227.GE6255@nowhere>
	 <20090512191848.25764af6@gondolin>
Date: Wed, 13 May 2009 08:28:15 +0800
Message-ID: <d82e647a0905121728m278b604bn9a0f5122b964978a@mail.gmail.com>
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
From: Ming Lei <tom.leiming@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, arjan@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/13 Cornelia Huck <cornelia.huck@de.ibm.com>:
> On Tue, 12 May 2009 18:52:29 +0200,
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> This division would make more sense indeed.
>>
>> - async_schedule_inatomic() would be nosync() and would use
>>   GFP_ATOMIC. I guess the case where we want to run
>>   a job synchronously from atomic in case of async failure is too rare
>>   (non-existent?).
>
> It would add complexity for those callers providing a function that is
> safe to be called in both contexts.
>
>> - async_schedule_nosync() would be only nosync() and would use
>>   GFP_KERNEL
>>
>> I'm not sure the second case will ever be used though.
>
> It might make sense for the "just fail if we cannot get memory" case.
>
>>
>> Another alternative would be to define a single async_schedule_nosync()
>> which also takes a gfp flag.
>
> Wouldn't async_schedule() then need a gfp flag as well?
>

IMHO, we should call async_schedule*() from non-atomic contexts and
async_schedule_inatomic*() from atomic contexts explicitly, so
async_schedule*()
use GFP_KERNEL and async_schedule_inatomic*() use GFP_ATOMIC
always. This can simplify the problem much more.

Also we still allow async_schedule*()  to run a job synchronously if
out of memory
or other failure. This can keep consistency with before.

Any sugesstions or objections?

-- 
Lei Ming

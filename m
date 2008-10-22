Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbYJVSbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbYJVSbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYJVSbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:31:05 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:32876 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYJVSbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:31:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DEa8PNIUR1ltCVdP0/ja1JsT21gYpGsN2f93Fmnu+kZDWvRp90uCJgPBn4k+LX679v
         8vyHj9qssR9LIvt60kVMsGm7J9Z/E44cp9mMHefuj3gO7o0XYIuPQPzsVThXbzZdAdaU
         c1Yd/CY1DCheE5kTtgYOJ6b0k7ivgAR5+Jvco=
Date: Wed, 22 Oct 2008 22:30:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
Message-ID: <20081022183055.GN9639@localhost>
References: <Pine.LNX.4.64.0810220926130.7633@quilx.com> <20081022163530.GH9639@localhost> <20081022165354.GI9639@localhost> <20081022172103.GJ9639@localhost> <Pine.LNX.4.64.0810221037320.7633@quilx.com> <48FF6800.20705@cs.helsinki.fi> <20081022175827.GL9639@localhost> <Pine.LNX.4.64.0810221110060.27088@quilx.com> <20081022181556.GM9639@localhost> <Pine.LNX.4.64.0810221123150.17454@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810221123150.17454@quilx.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Lameter - Wed, Oct 22, 2008 at 11:24:58AM -0700]
> On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:
>
>> [Christoph Lameter - Wed, Oct 22, 2008 at 11:10:56AM -0700]
>>> On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:
>>>
>>>> +#define OO_SHIFT	16
>>>> +#define OO_MASK		((1 << OO_SHIFT) - 1)
>>>> +#define MAX_OBJS_PER_PAGE	65535 /* see struct page.objects */
>>>
>>> This is == OO_MASK right? Otherwise things will break when we change
>>> OO_SHIFT.
>>>
>>
>> Yes, I set it 65535 directly to distinguish it from OO_MASK
>> meaning not value and point to page.objects since they are
>> u16. Which meant that is the point where all limits start.
>> So it we set OO_SHIFT to say 14 it will not be a problem
>> but if we exceed 16 bits it will break SLUB. Am I right?
>> (I become scratching the head :)
>
> If you set it > 16 then the size of the field in struct page is violated.
>
> So
>
> #define MAX_OBJ_PER_PAGE MIN(1 << bits_in(page.objects) - 1, OO_MASK)
>
> ?
>
>

Looks really good for me (if it worth anything). But Christoph
doesn't OO_SHIT inspired by u16 too which means we could use
MAX_OBJ_PER_PAGE in form you mentoined but maybe we should define

#define OO_SHIFT bits_in(page.objects) to point out why we use
16 not 14, not 18 or whatever? How do you think?

		- Cyrill -

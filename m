Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238Ab0ALAFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0ALAFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449Ab0ALAFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:05:42 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:33251 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0ALAFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:05:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pMynS5UaFL59NKxi0D5OcSUMo5ZsZU4EBkj2DeFXPYOdLiRb2rHKgVHLfYXM4dw1Li
         a0ocp//WyWcDOGCyWD/hxAxfkkMewkIr9kIk0WII5wUClug+W7bpv65ipfnN39eAnVFn
         IXoqnvZNbryuqTdJNDvLFJQd1kMwLi39Wt+M0=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1001112320490.7893@sister.anvils>
References: <20100111114224.bbf0fc62.minchan.kim@barrios-desktop>
	 <alpine.LSU.2.00.1001112320490.7893@sister.anvils>
Date: Tue, 12 Jan 2010 09:05:41 +0900
Message-ID: <28c262361001111605y3f887558wf3b8bb2ebff59a92@mail.gmail.com>
Subject: Re: [PATCH -mmotm-2010-01-06-14-34] Fix fault count of task in GUP
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 8:29 AM, Hugh Dickins
<hugh.dickins@tiscali.co.uk> wrote:
> On Mon, 11 Jan 2010, Minchan Kim wrote:
>>
>> get_user_pages calls handle_mm_fault to pin the arguemented
>> task's page. handle_mm_fault cause major or minor fault and
>> get_user_pages counts it into task which is passed by argument.
>>
>> But the fault happens in current task's context.
>> So we have to count it not argumented task's context but current
>> task's one.
>
> Have to?
>
> current simulates a fault into tsk's address space.
> It is not a fault into current's address space.
>
> I can see that this could be argued either way, or even
> that such a "fault" should not be counted at all; but I do not
> see a reason to change the way we have been counting it for years.
>
> Sorry, but NAK (to this and to the v2) -
> unless you have a stronger argument.

Okay. The I/O to get a page happen current's context.
So I thought we have to count it with current.
But now that I think about it, yes. It's not current's _fault_.
I agree with your opinion.

Thanks for correcting me. Hugh.



-- 
Kind regards,
Minchan Kim

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbZC0EcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbZC0EcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 00:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbZC0EcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 00:32:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:15545 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZC0EcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 00:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xVDIA1Ln4TadreQeB2ZEWhLGKZ7pW06qsaLLWxC/WfM9HWh6vWNX5Jol8maAipdjlZ
         yqsC/fPVzozTeKQibBqL5cutYDleVit5jkvaaS1NKI+JHY5GrHZKM4jxAJ+7bYO6/AH+
         KQdkXtwZJzkxv6e1t4iTsTPB/iELqVTDTynXo=
MIME-Version: 1.0
In-Reply-To: <28c262360903261912n4ce235c6wf2f75b2be7faf0f4@mail.gmail.com>
References: <28c262360903261912n4ce235c6wf2f75b2be7faf0f4@mail.gmail.com>
Date: Fri, 27 Mar 2009 13:32:05 +0900
Message-ID: <28c262360903262132n1f3d3c1ctbbafa1bc22dc3ddd@mail.gmail.com>
Subject: Re: Question about PRIVATE_FUTEX
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Eric Dumazet <dada1@cosmosbay.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, It seems even shared futex, too.

After calling get_user_pages_fast, get_futex_key calls unlock, put_page, too.
Then futex_wait  calls get_futex_value_locked.
Wouldn't kernel reclaim the page between get_fuex_key and
get_futex_value_locked ?

How do we make sure this race condition ?


On Fri, Mar 27, 2009 at 11:12 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> Hi, Peter and Eric.
>
> I am not expert about futex.
> I am sorry if this is dumb question.
>
> If we use private futex, get_futex_key don't call get_user_pages_fast
> which pins page at page table.
> Then, get_futex_value_locked calls __cpy_from_user_inatomic with
> pagefault_disable.
>
> Who make sure the user page is mapped at app's page table ?
>
> --
> Kinds regards,
> Minchan Kim
>



-- 
Kinds regards,
Minchan Kim

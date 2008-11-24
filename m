Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYKXVC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYKXVC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 16:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYKXVCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 16:02:49 -0500
Received: from smtp-out.google.com ([216.239.45.13]:62948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYKXVCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 16:02:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=iv8FS+CNsMnlHloYYkb+H7kNYvCAisp0l847r53MOFKrl5tyUR53RJtKyhEglyQYk
	Wz+Jk//3h2KBxRtnOIQfQ==
MIME-Version: 1.0
In-Reply-To: <6599ad830811241202o74312a18m84ed86a5f4393086@mail.gmail.com>
References: <604427e00811211731l40898486r1a58e4940f3859e9@mail.gmail.com>
	 <6599ad830811241202o74312a18m84ed86a5f4393086@mail.gmail.com>
Date: Mon, 24 Nov 2008 13:02:45 -0800
Message-ID: <604427e00811241302t2a52e38etffca2546f319a7af@mail.gmail.com>
Subject: Re: [PATCH][V3]Make get_user_pages interruptible
From: Ying Han <yinghan@google.com>
To: Paul Menage <menage@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>,
       Rohit Seth <rohitseth@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 12:02 PM, Paul Menage <menage@google.com> wrote:
> On Fri, Nov 21, 2008 at 5:31 PM, Ying Han <yinghan@google.com> wrote:
>> From: Paul Menage <menage@google.com>
>
> This patch is getting further and further from my original internal
> changes, so I'm not sure that a From: line from me is appropriate.
>
>>                         */
>> -                       if (unlikely(test_tsk_thread_flag(tsk, TIF_MEMDIE)))
>> -                               return i ? i : -ENOMEM;
>> +                       if (unlikely(sigkill_pending(tsk)))
>> +                               return i ? i : -ERESTARTSYS;
>
> You've changed the check from sigkill_pending(current) to sigkill_pending(tsk).
>
> I originally made that sigkill_pending(current) since we want to avoid
> tasks entering an unkillable state just because they're doing
> get_user_pages() on a system that's short of memory. Admittedly for
> the main case that we care about, mlock() (or an mmap() with
> MCL_FUTURE set) then tsk==current, but philosophically it seems to me
> to be more correct to do the check against current than tsk, since
> current is the thing that's actually allocating the memory. But maybe
> it would be better to check both?
In most of cases, tsk==current in get_user_pages(), that is why i
change current to tsk since
tsk is a superset of current, no? If that is right, why we need to check both?
>
> Paul
>

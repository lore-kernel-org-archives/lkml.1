Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbYKXWtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbYKXWtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 17:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbYKXWtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 17:49:21 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45532 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbYKXWtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 17:49:20 -0500
Message-ID: <492B2E83.7010605@cs.helsinki.fi>
Date: Tue, 25 Nov 2008 00:45:23 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Ying Han <yinghan@google.com>
CC: Paul Menage <menage@google.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rohit Seth <rohitseth@google.com>
Subject: Re: [PATCH][V3]Make get_user_pages interruptible
References: <604427e00811211731l40898486r1a58e4940f3859e9@mail.gmail.com>	 <6599ad830811241202o74312a18m84ed86a5f4393086@mail.gmail.com>	 <604427e00811241302t2a52e38etffca2546f319a7af@mail.gmail.com>	 <84144f020811241313o7401e3c2gd360c4226f33b28f@mail.gmail.com> <604427e00811241350j25b7b483p1d171ea1b5b6f8bf@mail.gmail.com>
In-Reply-To: <604427e00811241350j25b7b483p1d171ea1b5b6f8bf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ying Han wrote:
> thanks Pekka and i think one example of the case you mentioned is in
> access_process_vm() which is calling
> get_user_pages(tsk, mm, addr, 1, write, 1, &pages, &vma). However, it
> is allocating only one page here which
> much less likely to be stuck under memory pressure. Like you said, in
> order to make it more flexible for future
> changes, i might make the change like:
>>>>>                         */
>>>>> -                       if (unlikely(test_tsk_thread_flag(tsk, TIF_MEMDIE)))
>>>>> -                               return i ? i : -ENOMEM;
>>>>> +                       if (unlikely(sigkill_pending(current) | | sigkill_pending(tsk)))
>>>>> +                               return i ? i : -ERESTARTSYS;
> 
> is this something acceptable?

The formatting is bit wacky but I'm certainly OK with the change.

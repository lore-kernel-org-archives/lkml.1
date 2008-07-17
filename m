Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbYGQMzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbYGQMzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 08:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYGQMz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 08:55:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:25821 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYGQMz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 08:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nwkmlLMj7oxR4+5pgggtm/WVwdejV0N5vHcXT3XLUcopuHtfBAlvdhkStgKMkHwscQ
         fHMwTKU5yjvLOp+2z5lwuM3aTTvHe5wv1l6VQ4uU1zSdLv7ZYTWuZYa6++Y32WE4bPhu
         qAyvLWNKM26hWUFbJVPFdnt74OXVQmo6WUpDk=
Message-ID: <19f34abd0807170555j16599a8es2e8089d519cf346f@mail.gmail.com>
Date: Thu, 17 Jul 2008 14:55:26 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Robin Holt" <holt@sgi.com>
Subject: Re: SLUB: simplify re on_each_cpu()
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080717123906.GH8534@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080716172902.GA5176@martell.zuzino.mipt.ru>
	 <20080717113826.GG8534@sgi.com>
	 <84144f020807170526x6f013357i29280595f65a67f4@mail.gmail.com>
	 <20080717123906.GH8534@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 2:39 PM, Robin Holt <holt@sgi.com> wrote:
> On Thu, Jul 17, 2008 at 03:26:46PM +0300, Pekka Enberg wrote:
>> Hi Robin,
>>
>> On Wed, Jul 16, 2008 at 09:29:02PM +0400, Alexey Dobriyan wrote:
>> >> on_each_cpu() expands to function call on UP, too.
>>
>> On Thu, Jul 17, 2008 at 2:38 PM, Robin Holt <holt@sgi.com> wrote:
>> > It looks to me like on_each_cpu is a #define for !SMP.  Are you certain
>> > of the need for this change?  Are you looking at a different tree than
>> > Linus'?
>>
>> I think it's actually you who is looking at an older tree.
>
> I did a git-checkout of
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> which got me commit id 33af79d12e0fa25545d49e86afc67ea8ad5f2f40
> and looked at include/linux/smp.h line 123.  It has:
>
> #define on_each_cpu(func,info,wait)             \
>        ({                                      \
>                local_irq_disable();            \
>                func(info);                     \

That's the function call right there :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

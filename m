Return-Path: <linux-kernel-owner+w=401wt.eu-S1760362AbXIVTca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbXIVTca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 15:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXIVTcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 15:32:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:26348 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbXIVTcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 15:32:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=k9O9HsqZgbf5c3FFBaig7gh0FfqDlJJaxrmZL1+aQYn4/KFrnwV7apczA7nPUkkCR9OGG+y2kC47TKXfc1T5+hvTHon86wEleOngtHq47+LuhjHZ09EgE3gIk+Qg+8ZY7J+EQcRU2Ql1xp00KqbiK3aSFdin/VKwe+kSemnszJA=
Date: Sat, 22 Sep 2007 23:32:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: memset as memzero
Message-ID: <20070922193206.GA15911@cvg>
References: <20070922083355.GA7226@cvg> <20070922124659.741cca42@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070922124659.741cca42@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Arjan van de Ven - Sat, Sep 22, 2007 at 12:46:59PM -0700]
| On Sat, 22 Sep 2007 12:33:55 +0400
| Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > Hi list,
| > 
| > could anyone tell me why there is no official memzero function (or
| > macros) in the kernel.
| 
| it doesn't add value.... memset with a constant 0 is just as fast
| (since the compiler knows it's 0) than any wrapper around it, and the
| syntax around it is otherwise the same.
| 

It seems I expressed wrong. I'm worried about code duplication. Look
simple grep for memzero tells us that in particular:

...
-- arch/x86_64/boot/compressed/misc.c:110:#define memzero(s, n) memset ((s), 0, (n))
-- init/do_mounts_rd.c:279:#define memzero(s, n)     memset ((s), 0, (n))
-- init/initramfs.c:377:#define memzero(s, n)     memset ((s), 0, (n))
-- lib/inflate.c:331:  memzero(stk->c, sizeof(stk->c));
...

So instead of several 'define' that are the _same_ maybe better just use
_single common_ define? That's all I wanna ask. (Btw, it seems ARM has
a special case for memzero ;)

| 
| > As I see a lot of  kernel parts calls for it
| > (defying own macros as alias to memset). Maybe there is a special
| > reason not to do so? Actually my suggestion is to define _one_
| > general macros for this.
| 
| my suggestion is to nuke all the macros and just use memset().
| 

Quite clear, thanks. So if that is OK - I'm shutting up ;)

		Cyrill


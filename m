Return-Path: <linux-kernel-owner+w=401wt.eu-S1760506AbZLJXzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506AbZLJXzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 18:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758313AbZLJXzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 18:55:15 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:36189 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712AbZLJXzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 18:55:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U0zFcDoWwVdv+uV06ealQqtxy1SlZtkTjpseJsYR/dpzbBvh6fy7LKZfU8Ilx5T9kw
         APw7hw6o0ayWulNd7wk5cohAEfbGZrjQ8pJurunFS+5Zao7tIr0ZuobPTlD6+k1EOMih
         mxYkVpKb6o2H58MB0Dg9Uj9VB5mXGvjtjKnAg=
MIME-Version: 1.0
In-Reply-To: <20091210004703.308396881@linutronix.de>
References: <20091210001308.247025548@linutronix.de>
	 <20091210004703.308396881@linutronix.de>
Date: Fri, 11 Dec 2009 00:55:18 +0100
Message-ID: <19f34abd0912101555l659e96eal666f9876bd57f177@mail.gmail.com>
Subject: Re: [patch 8/9] Documentation: Fix invalid rcu assumptions
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Randy Dunlap <rdunlap@xenotime.net>,
       Vegard Nossum <vegardno@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[trimmed Cc]

>2) remove the stale signal code snippet
...
2009/12/10 Thomas Gleixner <tglx@linutronix.de>:
> Index: linux-2.6-tip/Documentation/kmemcheck.txt
> ===================================================================
> --- linux-2.6-tip.orig/Documentation/kmemcheck.txt
> +++ linux-2.6-tip/Documentation/kmemcheck.txt
> @@ -429,8 +429,7 @@ Let's take a look at it:
>  193         /*
>  194          * We won't get problems with the target's UID changing under us
>  195          * because changing it requires RCU be used, and if t != current, the
> -196          * caller must be holding the RCU readlock (by way of a spinlock) and
> -197          * we use RCU protection here
> +196          * caller must be holding the RCU readlocke
>  198          */
>  199         user = get_uid(__task_cred(t)->user);
>  200         atomic_inc(&user->sigpending);

I am not sure that I really agree with this change. This is not a code
example for the sake of showing how to do a particular thing, it's an
example of real code from the tree.

I don't remember if the document is referring to a particular git
version of the code, but I think it might not, in which case it
doesn't REALLY matter even on the microscopic level.

But I won't make a big fuss about it :-)


Vegard

PS: Upon closer inspection, I noticed that one line (line 197) goes
completely missing, there seems to be a typo there too, "readlocke".
Still it's not a huge deal, I admit.

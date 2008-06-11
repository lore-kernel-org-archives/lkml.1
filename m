Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbYFKOV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbYFKOV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYFKOVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:21:19 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:43847 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYFKOVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:21:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZBcZl9l8tFpXAvywudmQLyudI9035FCb6t2Tj1Zt3zBOx6LShQkUZLyM71GP8K/XwL
         RXNxT3634jLDOokKiQPv7tsIUt0eOwGTQ65q+VtBNo2pfr6ICw0tUaqR6h0Ye4I6yBT5
         HfXfj6k1fLR+pxvdWbv7rnpMZN+OcqoMCoS04=
Message-ID: <b647ffbd0806110721v187d2aadxf0e4395ea977f1af@mail.gmail.com>
Date: Wed, 11 Jun 2008 16:21:17 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: [PATCH] bugfix: was Re: [ linus-git ] prctl(PR_SET_KEEPCAPS, ...) is broken for some configs, e.g. CONFIG_SECURITY_SELINUX
Cc: "Chris Wright" <chrisw@sous-sol.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <484F1E63.8070408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212932321.4675.9.camel@earth> <484BF662.9070100@kernel.org>
	 <20080608110630.08a45cc6.akpm@linux-foundation.org>
	 <484C5E84.2020307@kernel.org>
	 <20080608163926.56f1be3d.akpm@linux-foundation.org>
	 <20080609171741.GA13403@us.ibm.com> <484E0280.2050305@kernel.org>
	 <20080610191451.GL4018@sequoia.sous-sol.org>
	 <484F1E63.8070408@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/11 Andrew G. Morgan <morgan@kernel.org>:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Chris Wright wrote:
> |> +    switch (option) {
> |> +    case PR_CAPBSET_READ:
> |> +            *rc_p = (cap_valid(arg2) ? 1 : -EINVAL);
> |> +            break;
> |
> | Do we need this one?  It's new to 2.6.25, so I think we could not
> | worry about emulating it here.
>
> We're talking about 'fixing' 2.6.26 no? I'd rather not open up the
> possibility that I have to 'fix' it again because of dropping a feature
> of 2.6.25... (Forgive me if I sound like I'm climbing out of a septic
> tank here.)
>
> Dmitry: please verify this change addresses your problem...

well, I fixed it on my side with another approach before sending a
report for this "problem".

It was not immediatelly clear to me that the concept of "process
capabilities" (as described in "man prctl" as follows
"Set  the state of the process's "keep capabilities" flag...")
is not applicable to all possible configuration, meaning that each
configuration have to support it in some way or another.

Moreover, according to commit's description the changes were supposed
to be 'nop' for all configs besides when one freshly ntroduced is
enabled.

Should it have been explicitly specified that thanks to this commit
prctl(KEEPCAPS, ...) turns into "a good citizen" (i.e. stops lying to
userspace about its support of capabilities -- if that's what is
desired), it'd change a further flow of events :-)

ok, anyway, I don't have access to my machine at the moment and can't
guarantee that I'll be able to do a test today.
You may try it with one of the configs I mentioened + a program doing
prctl(KEEPCAPS, 1, ...).

>From what I see, yes, it should address this issue.

btw., if I recall right capget() is still "lying" now. capset() did
give an error but Ubuntu's dhclient is somewhat inconsistent as it
checks for a return value of prctl() but not capset().


>
> Cheers
>
> Andrew


-- 
Best regards,
Dmitry Adamushko

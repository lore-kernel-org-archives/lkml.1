Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbZAGJeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbZAGJeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 04:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757199AbZAGJd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 04:33:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59652 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbZAGJd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 04:33:56 -0500
Message-ID: <496476D0.5040607@zytor.com>
Date: Wed, 07 Jan 2009 01:33:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC -tip 0/4] x86: reduce fixup of uaccess
References: <4962CAAE.6090300@ct.jp.nec.com>
In-Reply-To: <4962CAAE.6090300@ct.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> This is my second try to reduce fixup code size for exceptions of uaccess.
> 
> This patch series reduces fixup code for exceptions of uaccess in signal.
> 
> I gave up to make direct jump to end of function when an exception occurs.
> However, I thought fixup code could be reduced. The concept is that to add
> uaccess_err in thread_info and set it to -EFAULT on exception, finally check
> this value on the last of function.
> 
> Is this good to reduce code size?
> 

Hello Hiroshi,

The patches look technically really nice.  I have a couple of stylistic
comments, though, which I'd like yours and others' comments on.

This introduces a new blocking construct, and it's not immediately
obvious in the source code.  I think introducing a technically redundant
set of braces and dropping the parens from the try construct and the
redundant pointer might look better:

	get_user_try {
		/* do stuff */
	} get_user_catch(err);

This makes it, in my opinion, much clearer that it is a new bracing
construct, and it also eliminates the need to form a pointer to "err"
(even though the compiler doesn't actually do so, it looks like it does
to the programmer.)

Also, I don't think we need double underscores for the wrapping
construct, since the get_user/__get_user (check/nocheck) etc.
distinction doesn't directly apply there.

What do you think?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


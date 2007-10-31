Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbXJaVKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbXJaVKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXJaVKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:10:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48138 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbXJaVK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:10:29 -0400
Message-ID: <4728EE43.2080206@zytor.com>
Date: Wed, 31 Oct 2007 14:06:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Kirill A. Shutemov" <k.shutemov@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Unexport asm/user.h and linux/user.h
References: <1193845777-2007-1-git-send-email-k.shutemov@gmail.com> <1193845777-2007-3-git-send-email-k.shutemov@gmail.com>
In-Reply-To: <1193845777-2007-3-git-send-email-k.shutemov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> Do not export asm/user.h and linux/user.h during make headers_install.
> 
> Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
> Reviewed-By: David Woodhouse <dwmw2@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>

The version that is in there is currently broken from a user-space 
perspective (gdb expects u_ar0 to be struct user_regs_struct *, which it 
isn't for a bunch of the architectures defined); it *could* be argued 
the right thing is to fix it up since it *does* export an ABI
-- specifically, the format of a.out core dumps -- but it is probably 
easier to just axe it; userspace has had to deal with this issue on its 
own for a long time already.

As such,

Acked-by: H. Peter Anvin <hpa@zytor.com>


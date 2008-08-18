Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbYHRTAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbYHRTAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932238AbYHRS6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:58:38 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:48317 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbYHRS6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LqCgvBlxF+N4If1RK+btevPV7g7EggQu3Dr2dL3H20cy3DGa5xF58dU7LMKHwS9CSz
         MQadZgx6hJwZQ0ySHeHHdbz1LXFOdNH2FOQmfDcC69fKce6RMQcJXPOhV9zSILJ6XUFr
         2JaA3qViiVGQ9P+KQYj6MULu9lMDFG5x9G1Sk=
Message-ID: <19f34abd0808181158k6eaac7f9hd99d9eceea5114a@mail.gmail.com>
Date: Mon, 18 Aug 2008 20:58:35 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] Fix security.h compilation with !CONFIG_SECURITY
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       "Andi Kleen" <ak@linux.intel.com>,
       "David Howells" <dhowells@redhat.com>,
       "James Morris" <jmorris@namei.org>
In-Reply-To: <1219042537-13839-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219042537-13839-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 8:55 AM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> This recent patch
>
> commit 5cd9c58fbe9ec92b45b27e131719af4f2bd9eb40
> Author: David Howells <dhowells@redhat.com>
> Date:   Thu Aug 14 11:37:28 2008 +0100
>
>    security: Fix setting of PF_SUPERPRIV by __capable()
>
> broke compilation with !CONFIG_SECURITY:
>
> linux/include/linux/security.h: In function 'security_ptrace_traceme':
> linux/include/linux/security.h:1760: error: 'parent' undeclared (first use in this function)
>
> Add the obvious fix.
>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  include/linux/security.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 2ee5ecf..0cc23a1 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1757,7 +1757,7 @@ static inline int security_ptrace_may_access(struct task_struct *child,
>
>  static inline int security_ptrace_traceme(struct task_struct *child)
>  {
> -       return cap_ptrace_traceme(parent);
> +       return cap_ptrace_traceme(child);
>  }
>
>  static inline int security_capget(struct task_struct *target,
> --

Oops. I just submitted a similar patch. But I think yours is wrong.

The argument name should be "parent", as in the definition that is
provided when CONFIG_SECURITY=y.

    int security_ptrace_traceme(struct task_struct *parent);

I'm sorry for the double submit.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbZASLD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbZASLD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 06:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbZASLDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 06:03:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:28591 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728AbZASLDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 06:03:47 -0500
Message-ID: <154e089b0901190303k46b9a223of08923ee11ed873b@mail.gmail.com>
Date: Mon, 19 Jan 2009 12:03:44 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: [PATCH] creds: suppress warning in get_cred
Cc: "David Howells" <dhowells@redhat.com>, "James Morris" <jmorris@namei.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090119211031.934b4c19.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090119211031.934b4c19.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 11:10 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> This is the usual way to force a conversion from a const pointer to a
> non-const one and gets rid of this warning:
>
> include/linux/cred.h: In function 'get_cred':
> include/linux/cred.h:188: warning: passing argument 1 of 'get_new_cred' discards qualifiers from pointer target type
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/cred.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/cred.h b/include/linux/cred.h
> index 3282ee4..ed38227 100644
> --- a/include/linux/cred.h
> +++ b/include/linux/cred.h
> @@ -12,6 +12,7 @@
>  #ifndef _LINUX_CRED_H
>  #define _LINUX_CRED_H
>
> +#include <linux/types.h>
>  #include <linux/capability.h>
>  #include <linux/key.h>
>  #include <asm/atomic.h>
> @@ -185,7 +186,7 @@ static inline struct cred *get_new_cred(struct cred *cred)
>  */
>  static inline const struct cred *get_cred(const struct cred *cred)
>  {
> -       return get_new_cred((struct cred *) cred);
> +       return get_new_cred((struct cred *)(uintptr_t)cred);
>  }
>
>  /**

This is most likly a compiler bug, see

http://lkml.org/lkml/2008/11/20/441 and followups.

-Hannes

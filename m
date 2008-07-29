Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbYG2A1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbYG2A1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYG2A13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:27:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58098 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbYG2A12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:27:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=NMsbSCyGkuSmTo7KW3eRXJXftoBQFbnXilbuhlIZk5sU80vUblgb8wBYNH1wfXDyA
	UmF36QlXJ3F6p1IcA3PSw==
Message-ID: <6599ad830807281727r63a57a1g11972c5395828aae@mail.gmail.com>
Date: Mon, 28 Jul 2008 17:27:15 -0700
From: "Paul Menage" <menage@google.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Introduce down_try() so we can move away from down_trylock()
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Matthew Wilcox" <matthew@wil.cx>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>
In-Reply-To: <200807291015.02865.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807291015.02865.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 5:15 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> I planned on removing the much-disliked down_trylock() (with its
> backwards return codes) in 2.6.27, but it's creating something of a
> logjam with other patches in -mm and linux-next.
>
> Andrew suggested introducing "down_try" as a wrapper now, to make
> the transition easier.  Linus, please apply.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/semaphore.h |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff -r 92664ae4130b include/linux/semaphore.h
> --- a/include/linux/semaphore.h Wed May 21 14:54:40 2008 +1000
> +++ b/include/linux/semaphore.h Wed May 21 15:07:31 2008 +1000
> @@ -48,4 +48,18 @@ extern int __must_check down_timeout(str
>  extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
>  extern void up(struct semaphore *sem);
>
> +/**
> + * down_try - try to down a semaphore, but don't block
> + * @sem: the semaphore
> + *
> + * This is equivalent to down_trylock(), but has the same return codes as
> + * spin_trylock and mutex_trylock: 1 if semaphore acquired, 0 if not.

Is there a reason to avoid using a return type of "bool" for this?

Paul

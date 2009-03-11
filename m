Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbZCKShQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbZCKShQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZCKShB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:37:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:8662 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbZCKShA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uLnnOvkDJZbJ6gFw/CTbgcgodVF5tu0/xn5yhrskD7jS2bbvbHVvQ/VepyhX9u1fnu
         Tmb95CotjXLaBOQ+EaSF4w1TLc7/0ymU2IAYbg9HNEZSk6/VFmT8OUY7Da4tPdzNy9N7
         E9zlTjoNtzF5o4xQM/VD+7qZ2ExALn+PXJxrU=
MIME-Version: 1.0
In-Reply-To: <1234958676-27618-7-git-send-email-tj@kernel.org>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
	 <1234958676-27618-7-git-send-email-tj@kernel.org>
Date: Wed, 11 Mar 2009 11:36:58 -0700
Message-ID: <12c511ca0903111136h3805a106i484a32fd2972c568@mail.gmail.com>
Subject: Re: [PATCH 06/10] percpu: kill percpu_alloc() and friends
From: Tony Luck <tony.luck@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 5:04 AM, Tejun Heo <tj@kernel.org> wrote:
> +static inline void *__alloc_percpu(size_t size, size_t align)
>  {
> +       /*
> +        * Can't easily make larger alignment work with kmalloc.  WARN
> +        * on it.  Larger alignment should only be used for module
> +        * percpu sections on SMP for which this path isn't used.
> +        */
> +       WARN_ON_ONCE(align > __alignof__(unsigned long long));
>        return kzalloc(size, gfp);
>  }

This WARN_ON just pinged for me when I built & ran linux-next tag next-20090311

Stack trace from the WARN_ON pointed to __create_workqueue_key() which
does:

         wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);

and the cpu_workqueue_struct is defined as ____cacheline_aligned

I hit this on ia64, but all this code looks generic.

-Tony

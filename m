Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbXHAXtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbXHAXtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbXHAXtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:49:12 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:43505 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbXHAXtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:49:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=V/Sreh2Gyjawxu7o0E123b4utVAvGw4L+czTmCQ3phk7M8NyXrh8WqazEmWZY
	THF92LNG++yL1mfxQlql0j6BA==
Date: Thu, 2 Aug 2007 01:49:02 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, rmk@arm.linux.org.uk,
       tglx@linutronix.de
Subject: Re: [PATCH][RFC] unbreak generic futex_atomic_cmpxchg_inatomic() on UP
Message-ID: <20070801234902.GA5415@xi.wantstofly.org>
References: <200708012300.l71N0LRX008930@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708012300.l71N0LRX008930@harpo.it.uu.se>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 01:00:21AM +0200, Mikael Pettersson wrote:

> @@ -52,7 +53,34 @@ futex_atomic_op_inuser (int encoded_op, 
>  static inline int
>  futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
>  {
> +#ifdef CONFIG_SMP
>  	return -ENOSYS;
> +#else

Since the callers of futex_atomic_cmpxchg_inatomic() don't really
seem prepared to deal with -ENOSYS (e.g. the handle_futex_death()
infinite loop when it gets -ENOSYS), it seems better never to
return -ENOSYS from this function at all.

What if you just stick an #error in here in the SMP case?

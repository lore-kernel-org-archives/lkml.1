Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbXGHURw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbXGHURw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 16:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbXGHURm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 16:17:42 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:28561 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbXGHURl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 16:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M3i8CqLFrYx6xQi0GJs7U8wF6sZE6ZW7s3l2KFPBCMKGt/RUXK+22G8NPcPMd4ucpgg8FkJe+GGYBzIyhp3S32Ux0Fuzhl47nXU2VK3yMiLF/uMlGH4UubpG3jZNf9KV1kAsAu7qQv3knMfSMDq/5/T3ghzw6olQSgKsKgTb5Mc=
Message-ID: <3efb10970707081317k22de079dr9a5cad6a42cf5b3b@mail.gmail.com>
Date: Sun, 8 Jul 2007 22:17:40 +0200
From: "Remy Bohmer" <l.pinguin@gmail.com>
Reply-To: linux@bohmer.net
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: PI mutex support on ARM
Cc: "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <20070708095841.GA4601@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970707080124i7a9323c5o9257b4adcb2ac493@mail.gmail.com>
	 <20070708095841.GA4601@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

> patch format problem: never diff the asm/ files, diff the asm-arm/ files.
Yeah, of course, I know, I believe I made a real mess of this one ...

> is it safe to do a get_user() with irqs off?
rhetorical question ;-))
I was wondering, Is it safe to use a normal spinlock here, like this?

------- 8-< -------------
	spin_lock(&futex_lock);

	err = get_user(uval, uaddr);
	if ((!err) && (uval == oldval))
		err = put_user(newval, uaddr);

	spin_unlock(&futex_lock);
------- 8-< -------------

> is this method of atomic ops SMP-safe?
another rhetorical question ;-))
Nope, I already knew that, that why I mentioned that it probably only
worked on UP...

Remy

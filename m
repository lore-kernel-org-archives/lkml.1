Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYI2ORd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYI2ORd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 10:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYI2ORY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 10:17:24 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36470 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbYI2ORX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 10:17:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=yA6oR20X7aYvASZpqSoMtZgADv9cNsDD84quEOxvwWnstIXuQca0kNTSV3ZwA535Xi
         VTgXvj/mM/4IfGWwD4cwXrwQStySycKRBoG6YlcPrhDi5hBDoC5tteh3xUXcyB44Ku6A
         a05cycgweox6P+Ok/8f0vBBFVuYORyZLbOhMw=
Message-ID: <7d1d9c250809290717y5824118fhdda40a9b59d65614@mail.gmail.com>
Date: Mon, 29 Sep 2008 10:17:22 -0400
From: "Paul Gortmaker" <paul.gortmaker@gmail.com>
To: "John Kacur" <jkacur@gmail.com>
Subject: Re: [PATCH]Real-time kernel compile-fix for 32-bit when disabling CONFIG_PREEMPT_RT
Cc: RT <linux-rt-users@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       "Leon Woestenberg" <leon.woestenberg@gmail.com>
In-Reply-To: <520f0cf10809290110m6574d983h3b581443b2256cf5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <520f0cf10809290110m6574d983h3b581443b2256cf5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 4:10 AM, John Kacur <jkacur@gmail.com> wrote:
> If you start with the real-time kernel linux-2.6.26.5-rt9 and
> configure it to disable CONFIG_PREEMPT_RT, for example
> CONFIG_PREEMPT_DESKTOP=y
> # CONFIG_PREEMPT_RT is not set
>
> you will get the following compile error on 32-bit i386. (actually,
> this will happen on any platform that doesn't use
> CONFIG_RWSEM_GENERIC_SPINLOCK)

[...]

> include/linux/rwsem.h:149: error: redefinition of 'rwsem_is_locked'
> include/asm/rwsem.h:261: error: previous definition of
> 'rwsem_is_locked' was here
> include/linux/rwsem.h: In function 'rwsem_is_locked':
> include/linux/rwsem.h:151: error: implicit declaration of function
> 'compat_rwsem_is_locked'
> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
>
> The fix is simple, and should be folded back into the rt-mutex-core.patch
> Fix is attached.

I saw this too, and was about to send a fix along with some other fixes
I'd stumbled across.  However, looking at the other arch implementations,
I think the fix is different from what you've posted -- i.e. I think it should
be simply this:

-static inline int rwsem_is_locked(struct compat_rw_semaphore *sem)
+static inline int compat_rwsem_is_locked(struct compat_rw_semaphore *sem)

I'll get the actual patch for this and two other compile fixes sent along
in a few minutes.

Paul.

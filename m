Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbZGVX2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbZGVX2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZGVX2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:28:39 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:33860 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbZGVX2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EH7+2UUPFQ31+2O/0uN0/hWhAnjRfucs11u7IrMEHIUV0oghC9tDTHvrNys6+HkeGk
         R2rq0QFX5hRKWxW3nevoWe3i5H2m8otv2Tpm4oyRGSzOkSvJgVNGwFePU1SNDod+0KeP
         xtJsEHeJYi7b1chcqeEa3gV5hL4ua/zfwnRIo=
Message-ID: <4A67A0A2.40503@gmail.com>
Date: Wed, 22 Jul 2009 20:28:34 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090626)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] genirq fixes for 2.6.31
References: <alpine.LFD.2.00.0907221655130.2813@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907221655130.2813@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> +/*
>   * Interrupt handler thread
>   */
>  static int irq_thread(void *data)
> @@ -458,6 +494,8 @@ static int irq_thread(void *data)
>  
>  	while (!irq_wait_for_interrupt(action)) {
>  
> +		irq_thread_check_affinity(desc, action);
> +
>  		atomic_inc(&desc->threads_active);
>  
>  		spin_lock_irq(&desc->lock);

Any chance we could do this in a way that doesn't break the build for CONFIG_SMP=n? :)

Should this call simply be wrapped in an #ifdef, or should the function be defined for !SMP?

-- 
Kevin Winchester



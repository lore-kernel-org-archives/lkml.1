Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbXKKVLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbXKKVLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 16:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXKKVL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 16:11:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:50864 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbXKKVL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 16:11:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dn2uh8/835COKYR6izzoa95YujJuxqctVbC1xCsvsgY0cHgZQPkK2fObLyK4FphGhRyB+h+7ckjP74ljCQ5d4Tj+qj8kZpwBmVArHmE7hz+FBF9tDDY9FxYGpz393bZyFgGPYQxptHHVsSs0T65QPNiYjE1mA132mGqbv5YUNTc=
Message-ID: <b647ffbd0711111311x4e35f854g3ecfb8f07748d934@mail.gmail.com>
Date: Sun, 11 Nov 2007 22:11:27 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Adrian McMenamin" <lkmladrian@gmail.com>
Subject: Re: Race in setup_irq?
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
In-Reply-To: <8b67d60711111152he10da17o44bb124e96373ebc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60711111152he10da17o44bb124e96373ebc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2007, Adrian McMenamin <lkmladrian@gmail.com> wrote
> I am writing a device driver for the Dreamcast CD Drive (the "GD Rom")
> and I am hitting what looks like some sort of race in
> kernel/irq/manage.c. Can anybody point me in the right direction or is
> there a bug here?
>
> This never seems to return in setup_irq:
>
>         spin_unlock_irqrestore(&desc->lock, flags);
>
> (line 597)

I guess, you are referring to setup_irq() (the line without a
particular kernel version doesn't make much sense).

What do you mean by "never seems to return"? Does your machine hang?

If so, the reason might be some kind of (logical) error in your ISR.
spin_unlock_irqrestore() unmasks the interrupts and your target device
might have already generated an interrupt by this moment (sure, it
depends on the initialization logic of your code and device spec.)...
--> ISR runs and due to some error e.g. loops endlessly/deadlocks/etc.

Tried placing printk() at the beginning of ISR?

-- 
Best regards,
Dmitry Adamushko

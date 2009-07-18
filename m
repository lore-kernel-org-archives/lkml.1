Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbZGROLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbZGROLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZGROLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:11:50 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:57202 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZGROLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:11:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ieJ9eClbG+EZ4YrSQqEfNwG8yFzdf1sP3gYnlWd85q3SIKRE9s7TgD/yOBMI60ITX0
         y/gvf8LRSsJiz1xCq/hVM7diGS2cfyZAOoW3i+kBkQJHYSkYLZxGcJgQWPZbV7DXGscK
         T0XCSzpot0wtpFuyAoidBc2zccDP3M4Wa7rUw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0907181032210.11571@localhost.localdomain>
References: <1247820229-4983-1-git-send-email-21cnbao@gmail.com>
	 <alpine.LFD.2.00.0907171523100.11571@localhost.localdomain>
	 <3c17e3570907170758g337703b7l12e1c262d6f385bf@mail.gmail.com>
	 <alpine.LFD.2.00.0907171730070.11571@localhost.localdomain>
	 <3c17e3570907171626x3a319425wf0a813c079595f09@mail.gmail.com>
	 <alpine.LFD.2.00.0907181032210.11571@localhost.localdomain>
Date: Sat, 18 Jul 2009 22:11:47 +0800
Message-ID: <3c17e3570907180711i28a4a577wbc2437f22f913e2d@mail.gmail.com>
Subject: Re: [PATCH] Delete redundant IRQ_DISABLED check in irq_thread
From: Barry Song <21cnbao@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, dahlmann.thomas@arcor.de,
       LKML <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/18, Thomas Gleixner <tglx@linutronix.de>:
> On Sat, 18 Jul 2009, Barry Song wrote:
>> I guess people call disable_irq to disable the whole execution,
>> specially to disable the hardirq(then both top and bottom are
>> blocked). It's really strange the disable operation only blocks the
>> bottom-half.
>
> The disable blocks both. After the disable no hardirq comes in
> anymore.
>
I know disable_irq will block the future hardirq and bottom-half. Here
I means the current hardirq has been executed, but bottom-half will
not be executed because of the disable_irq. So the disable_irq only
blocks a half for the special case and the work of the current IRQ is
not finished fully in fact. But anyway, it should not cause trouble,
but just give the semantic of disable_irq a little confused.
Anyway, I agree it is not necessary to fulfill a complicated
check/sync for thread IRQ.

And thanks for your review and providing a good solution for my problem!

> The disabled check in the thread is just to take care of the case when
> the disable comes in between the hardirq and the thread handler.
>
> That way we avoid doing the full tracking of the hardirq / thread
> chain simply because it is complex and would produce significant
> overhead in the fast path for no gain. It could be done, but it's not
> worth the trouble.
>
> Thanks,
>
> 	tglx
>
>

Thanks,
Barry

Return-Path: <linux-kernel-owner+w=401wt.eu-S934480AbZDJTfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480AbZDJTfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 15:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933666AbZDJTfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 15:35:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:45088 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643AbZDJTfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 15:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PhOMIEK0pYqk4+8+uyVQmmfPvJt47s1HDcV6QZ59uQkzJetYebQVM/nc60wXlBcapv
         eZb8EnCDGe2Hu6v0bH6EgpKgZvRHVbKctr8Br5+zsA7CTY4WVU//TfL1dZP6AuRaGxuu
         hSPqAMdvIIxFtZq3RBAMoDFQWu48vHB+86gIg=
MIME-Version: 1.0
In-Reply-To: <20090410162915.GA27805@elf.ucw.cz>
References: <20090410103429.GA31367@elf.ucw.cz>
	 <f17812d70904100350l19fa7493ma9c4695d49d19398@mail.gmail.com>
	 <1239360967.14324.2.camel@brutus> <20090410162915.GA27805@elf.ucw.cz>
Date: Fri, 10 Apr 2009 23:35:04 +0400
Message-ID: <bc64b4640904101235l37b17da9hf52b8c841741dadd@mail.gmail.com>
Subject: Re: 2.6.30-rc1: touchscreen BUG() on spitz
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       omegamoon@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/10 Pavel Machek <pavel@ucw.cz>:
> Hi!
>
>> > > After update to 2.6.30-rc1, sharp zaurus c-3000 fails to boot with
>> > > white screen (with stripes). That's a regression w.r.t. 2.6.29.
>> >
>> > What kind of white stripes? Does it look like the LCD controller
>> > stops working or something.
>> >
>> > There is a regression which caused X server hang during bootup,
>> > with commit id 66c1ca0, which you can revert and have another
>> > try.
>>
>> As spitz also use cs_control for pxa2xx_spi, i believe that this is the
>> same issue i found wednesday.
>>
>> See the "Kernel freeze caused by
>> a7bb3909b3293d503211d7f6af8ed62c1644b686" thread.
>
> Ok, I'll try changing ASSERT->DEASSERT and see what happens. Hmm, it
> now boots, with these messages:
>
> WARNING: at kernel/irq/handle.c:366
> BUG: IRQ handler called from non-hardirq context!
>
> just after loading touchscreen device.

Try reverting 044d408409cc4e1bc75c886e27ca85c270db104c as
software resent IRQs are sent from tasklet context, not from hardirq.

-- 
With best wishes
Dmitry

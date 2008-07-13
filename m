Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbYGMSeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbYGMSeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYGMSeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:34:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:57513 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbYGMSeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bfAlmlbiJucks2RW/+kOzoXSLdY9BoqyRo5uyEFiZ3Dw1MLb3dTQFKyXuPr3k6H2FF
         vyb21j+HO52lqfspR9qFxnXCQkHIAmf/niCEzxGCYXu8M1yuFZxMZ/S9331to79MSekk
         L3L/vbZ7k/fEw1U1up8Unwl/7ohQaTPJeF5JU=
Message-ID: <86802c440807131134i351f967dh3a2b94d687c767ee@mail.gmail.com>
Date: Sun, 13 Jul 2008 11:34:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: per-cpu related?
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Mike Travis" <travis@sgi.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <19f34abd0807130455w516d73cfi80161c345564464@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440807130116u3b850485jec220bc15892873e@mail.gmail.com>
	 <19f34abd0807130455w516d73cfi80161c345564464@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 4:55 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi,
>
> On Sun, Jul 13, 2008 at 10:16 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> calling  pcie_portdrv_init+0x0/0x77
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
>> IP: [<ffffffff802557de>] hrtick_start_fair+0x8e/0x178
>> PGD 0
>> Oops: 0000 [1] SMP
>> CPU 4
>> Modules linked in:
>> Pid: 103, comm: events/4 Not tainted 2.6.26-rc9-tip-01834-g99e624f-dirty #354
>> RIP: 0010:[<ffffffff802557de>]  [<ffffffff802557de>]
>> hrtick_start_fair+0x8e/0x178
>
> I find that this corresponds to timer->base being NULL:
>
> static inline int hrtimer_is_hres_active(struct hrtimer *timer)
> {
>        return timer->base->cpu_base->hres_active;
> }
>
> Apparently timer->base can legitimately be NULL in some cases:

thanks

could be caused by max_low_pfn_mapped patch...because hpet still use
fixmap address that is cleared by others.

will check that.

YH

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYKIABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYKIABU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 19:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYKIABJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 19:01:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:46347 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbYKIABG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 19:01:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Khb2+boFRU3z8RglQ1zn9W7GpESgVehc7+GOPOPd8ruqsuwhGHGJ5BkT9Hfx4rwl/q
         GmMBMxSeReyiV44wmULPrPdFDMOWr3dqBkVc+JZX7YU1pmZ+1FZSoREMfXNHb0+450gD
         DHtUXD7dgcZBrvgg2LEf5oSq/Jtj5WrEge+co=
Message-ID: <86802c440811081601w2be45e55hc400095137831b85@mail.gmail.com>
Date: Sat, 8 Nov 2008 16:01:05 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/1] irq: Maintain user set affinity
Cc: "Kumar Gala" <galak@kernel.crashing.org>,
       "Linus Torvalds" <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, "Andrew Morton" <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <1226182645.13603.90.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0811041030520.25054@blarg.am.freescale.net>
	 <86802c440811081412u6d54beaam143801ce83225f40@mail.gmail.com>
	 <1226182645.13603.90.camel@pasglop>
X-Google-Sender-Auth: 0f013a385fefa069
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 8, 2008 at 2:17 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Sat, 2008-11-08 at 14:12 -0800, Yinghai Lu wrote:
>> On Tue, Nov 4, 2008 at 8:31 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
>> > From 819ad3ed4660f4238e053728a8b5aa93d22b13d7 Mon Sep 17 00:00:00 2001
>> > From: Kumar Gala <galak@kernel.crashing.org>
>> > Date: Tue, 4 Nov 2008 10:13:53 -0600
>> > Subject: [PATCH 1/1] irq: Maintain user set affinity
>> >
>> > This addresses a regression in that if a user specified an affinity
>> > for an interrupt that affinity information would get reset between
>> > a request_irq(), free_irq() and request_irq() for the same irq.
>> >
>> > On example of this is bringing up an ethernet interface, taking
>> > it down and bringing it back up again.
>> >
>> > Instead of always using the irq_default_affinity we use the
>> > previous setting of the IRQs affinity with the assumption that
>> > at boot the IRQs affinity will be set to irq_default_affinity.
>>
>> why ?, the default_affinity is expected behavior...
>>
>> for example: when MSI is used, second driver could get same irq if
>> first driver is unloaded.
>
> The default affinity should be set when the irq is allocated / assigned
> to a device, not when it's requested.

ok, you are right.

for MSI, affinity is set two times.

also in dynamic_irq_init is setting with
#ifdef CONFIG_SMP
        cpus_setall(desc->affinity);
#endif

it seems should use irq_default_affinity instead of CPU_MASK_ALL directly there.

YH

Return-Path: <linux-kernel-owner+w=401wt.eu-S932811AbXGZP5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811AbXGZP5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760755AbXGZP5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:57:11 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:51600 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760767AbXGZP5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:57:10 -0400
Message-ID: <2090.172.50.1.13.1185465429.squirrel@172.19.0.2>
In-Reply-To: <20070726162913.2dc9a9b2@the-village.bc.nu>
References: <1185437065.4805.19.camel@sebastian.kern.oss.ntt.co.jp>
    <d120d5000707260654l74d61359v4f17790ab06ac0a3@mail.gmail.com>
    <20070726151042.0ae34e0e@the-village.bc.nu>
    <1446.172.50.1.13.1185461396.squirrel@172.19.0.2>
    <20070726162913.2dc9a9b2@the-village.bc.nu>
Date: Fri, 27 Jul 2007 00:57:09 +0900 (JST)
Subject: Re: [PATCH] fix return value of i8042_aux_test_irq
From: fernando@oss.ntt.co.jp
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: fernando@oss.ntt.co.jp, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, vojtech@suse.cz,
       akpm@linux-foundation.org
User-Agent: SquirrelMail/1.4.8-2.el4
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, July 27, 2007 12:29 am, Alan Cox wrote:
>> > A small number of boxes do share IRQ12 and it was switched to shared
>> for
>> > them.
>> If that is the case interrupt handlers should be able to determine
>> whether
>> a certain interrupt comes from their respective devices, and return
>> IRQ_HANDLED or IRQ_NONE accordingly. Returning IRQ_HANDLED
>> unconditionally
>> when IRQF_SHARED is set seems strange. Is this behavior intended?
>
> Sometimes you simple can't tell and in those cases you have no choice.
As I mentioned in a previous email, i8042_interrupt considers that it
should not handle an interrupt when there is no data to read and,
accordingly, it returns IRQ_NONE in such cases. I was just wondering if we
could follow the same approach to make i8042_aux_test_irq more
IRQF_SHARED-friendly.

 - Fernando


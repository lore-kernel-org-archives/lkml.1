Return-Path: <linux-kernel-owner+w=401wt.eu-S1762444AbXGZOuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444AbXGZOuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbXGZOt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:49:59 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:51260 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbXGZOt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:49:58 -0400
Message-ID: <1446.172.50.1.13.1185461396.squirrel@172.19.0.2>
In-Reply-To: <20070726151042.0ae34e0e@the-village.bc.nu>
References: <1185437065.4805.19.camel@sebastian.kern.oss.ntt.co.jp>
    <d120d5000707260654l74d61359v4f17790ab06ac0a3@mail.gmail.com>
    <20070726151042.0ae34e0e@the-village.bc.nu>
Date: Thu, 26 Jul 2007 23:49:56 +0900 (JST)
Subject: Re: [PATCH] fix return value of i8042_aux_test_irq
From: fernando@oss.ntt.co.jp
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       Fernando Luis =?iso-8859-1?Q?V=C3=A1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
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

On Thu, July 26, 2007 11:10 pm, Alan Cox wrote:
>> The handler does handle the interrupt - both status and data registers
>> are read so from the keyboard controller point of view the interrupt
>> has been handled even if we happen to discard the data. As far as I
>> know IRQ12 is never shared by BIOS... Vojtech, do you remember why we
>> request IRQ12 with IRQF_SHARED?
>
> A small number of boxes do share IRQ12 and it was switched to shared for
> them.
If that is the case interrupt handlers should be able to determine whether
a certain interrupt comes from their respective devices, and return
IRQ_HANDLED or IRQ_NONE accordingly. Returning IRQ_HANDLED unconditionally
when IRQF_SHARED is set seems strange. Is this behavior intended?


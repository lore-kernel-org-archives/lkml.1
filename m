Return-Path: <linux-kernel-owner+w=401wt.eu-S1030986AbXDPVtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030986AbXDPVtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030985AbXDPVtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:49:53 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:43602 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030371AbXDPVtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:49:52 -0400
Date: Mon, 16 Apr 2007 14:49:51 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] Re: [GIT PATCHES] V4L/DVB updates
In-Reply-To: <d120d5000704160850m7c08debam9b0869cbb19cc593@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0704161443050.16569@shell2.speakeasy.net>
References: <1176653207.10849.5.camel@localhost>
 <d120d5000704160850m7c08debam9b0869cbb19cc593@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, Dmitry Torokhov wrote:
> Hi Mauro,
>
> On 4/15/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> >   - Fix Kernel Bugzilla #8301: spinlock fix for flexcop-pci
>
> While move of spin_lock_init before request_irq is obviously correct I
> wonder what is the reason behind changing spin_lock_irq() into
> spin_lock_irqsave() as I do not see flexcop_pci_isr being called from
> anywhere but IRQ context.
>
> BTW, is irq_lock needed at all?

There was some more discussion on the linux-dvb list
http://www.linuxtv.org/pipermail/linux-dvb/2007-April/017024.html , and I
think we came to the conclusion that irq_lock isn't needed at all.  It does
nothing but serialize the ISR and ISRs are automatically serialized by the
kernel.

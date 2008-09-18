Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbYIRS1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbYIRS1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbYIRS04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:26:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45422 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755864AbYIRS0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:26:55 -0400
Date: Thu, 18 Sep 2008 19:26:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Singaravelan Nallasellan" <singaravelann@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Interrupt Handler Invocation
Message-ID: <20080918192651.0cf315b9@lxorguk.ukuu.org.uk>
In-Reply-To: <3baf3d760809181057o5810f975w15647878a3033b30@mail.gmail.com>
References: <3baf3d760809181057o5810f975w15647878a3033b30@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 23:27:30 +0530
"Singaravelan Nallasellan" <singaravelann@gmail.com> wrote:

> Hi,
> 
> I am currently assuming that the ISR will be invoked repeatedly till
> the ISR says the IRQ is handled.  Is it a valid assumption?
> Can somebody throw some light on whether ISR is invoked repeatedly
> when the ISR returns the IRQ is not handled?

That depends whether the IRQ is cleared

> What is the behaviour for edge or level triggered interrupts?

Hardware dependant.

IRQ_HANDLED isn't used to indicate that the IRQ was processed and some
magic should occur, it is used so that the kernel can detect stuck
interrupts.

Generally speaking if you get an edge triggered IRQ and nobody handles it
then it will be lost and you may get the IRQ line stuck unusable forever.
If you get a level triggered IRQ and nobody handles it you will get
stuck repeatedly calling the IRQ handler until the kernel shuts that IRQ
off entirely to try and keep going.


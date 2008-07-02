Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbYGBLu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbYGBLu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759136AbYGBLuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:50:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43865 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756335AbYGBLuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:50:07 -0400
Date: Wed, 2 Jul 2008 12:31:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hjk@linutronix.de" <hjk@linutronix.de>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio: User IRQ Mode
Message-ID: <20080702123158.2c4fefc6@lxorguk.ukuu.org.uk>
In-Reply-To: <20080702114224.GB6891@digi.com>
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se>
	<20080702121153.4d464885@lxorguk.ukuu.org.uk>
	<20080702114224.GB6891@digi.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note that the irq is disabled instead of acked.  So this should not be a
> problem.  The userspace part then is responsible to ack (first) and
> unmask the irq.

That still doesn't make sense.

If you call disable_irq in the IRQ handler you will deadlock because it
waits until the IRQ handler has completed.

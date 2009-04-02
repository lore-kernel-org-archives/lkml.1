Return-Path: <linux-kernel-owner+w=401wt.eu-S1765693AbZDBWy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765693AbZDBWy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZDBWyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:54:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50471 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752721AbZDBWyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:54:50 -0400
Date: Thu, 2 Apr 2009 23:55:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Christophe Lermytte <christophe.lermytte@thomson.net>,
       linux-kernel@vger.kernel.org
Subject: Re: mutex_lock_slowpath warning using mxser tty driver
 (input/output error)
Message-ID: <20090402235508.31c7f2b6@lxorguk.ukuu.org.uk>
In-Reply-To: <49D51EDD.4060902@gmail.com>
References: <1238689565.14822.99.camel@thom>
	<1238696349.5133.25.camel@laptop>
	<20090402194401.154bbc36@lxorguk.ukuu.org.uk>
	<49D51EDD.4060902@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Apr 2009 22:23:57 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 04/02/2009 08:44 PM, Alan Cox wrote:
> >> It appears to want to lock a mutex in interrupt context, something
> >> that's a definite no-no.
> >>
> >> CCed the folks who might know a thing or two about the driver.
> > 
> > Moxa is not a USB driver so the USB trace at the end makes no sense at
> > all.
> 
> Yes, unreliable stack entries, but echo_set_canon_col is called from irq
> context and locks mutex.

Which means that either the driver is calling the ldisc receive handlers
from an IRQ directly (not allowed) or calling the tty_flip_buffer_push
paths and set tty->low_latency

2.6.29 is the first kernel that catches this bug with warnings.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757824AbZAHMNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbZAHMNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZAHMNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:13:12 -0500
Received: from mercury.realtime.net ([205.238.132.86]:37523 "EHLO
	mercury.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZAHMNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:13:11 -0500
From: Milton Miller <miltonm@bga.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
       Benjiman Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, Joe Peterson <joe@skyrush.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/5] hvc_console updates was Re: [BUG] hvc_console WARN() on current upstream
references: <1231404121.2142.50.camel@pasglop>
 <20090108111116.3f806d67@lxorguk.ukuu.org.uk>
In-Reply-To: <20090108111116.3f806d67@lxorguk.ukuu.org.uk>
Message-Id: <hvc-console-29-3@bga.com>
Date: Thu, 08 Jan 2009 06:12:58 -0600
X-Originating-IP: 205.232.218.56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Benjamin Herrenschmidt wrote:
>> Seems that we are in interrupt, doing hvc_poll, which does
>> tty_flip_buffer_push
>
>Which means that someone has tty->low_latency set and is calling
>tty_flip_buffer_push in an IRQ. That has never been allowed or safe, and
>now it hurts ;)
>
>/**
> *      tty_flip_buffer_push    -       terminal
> *      @tty: tty to push
> * 
> *      Queue a push of the terminal flip buffers to the line discipline.
>This
> *      function must not be called from IRQ context if tty->low_latency
>is set *
> *      In the event of the queue being busy for flipping the work will be
> *      held off and retried later.
> *
> *      Locking: tty buffer lock. Driver locks in low latency mode.
> */
>
>
>That comment has been there for some years in varying formats
>

I actually was preparing a patch for this problem after I had encountered
the a deadlock due to this.  That is in the first patch.   I then found
and made a few more cleanups, although I might have reordered the rest.

The history for setting low_latency is in the changelog of the first patch..

milton

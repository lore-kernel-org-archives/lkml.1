Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbXIIUqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbXIIUqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbXIIUq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:46:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45499 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbXIIUq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:46:26 -0400
Date: Sun, 9 Sep 2007 21:44:38 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: "Adrian McMenamin" <lkmladrian@gmail.com>
Cc: "Dmitry Torokhov" <dtor@insightbb.com>, "Paul Mundt" <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Maple bus support for the Sega Dreamcast - keyboard
 support
Message-ID: <20070909214438.79959ace@laptopd505.fenrus.org>
In-Reply-To: <8b67d60709091335u53d45547lb80651bfa0e01efe@mail.gmail.com>
References: <8b67d60709091001l3cd6adf6m2dab8e815f47435d@mail.gmail.com>
	<20070909193040.2fb9d010@laptopd505.fenrus.org>
	<8b67d60709091335u53d45547lb80651bfa0e01efe@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2007 21:35:11 +0100
"Adrian McMenamin" <lkmladrian@gmail.com> wrote:

> On 09/09/07, Arjan van de Ven <arjan@infradead.org> wrote:
> > On Sun, 9 Sep 2007 18:01:26 +0100
> > "Adrian McMenamin" <lkmladrian@gmail.com> wrote:
> >
> > > This patch adds support for the SEGA Dreamcast keyboard.
> > >
> > > Following suggestions from the inout maintainer it has been
> > > somewhat rewritten since the previous posting
> > > (http://lkml.org/lkml/2007/9/4/168).
> >
> > Hi,
> >
> > this driver in general is quite clean as well; I have only one
> > suggestion for improvement. Right now you use a semaphore for
> > locking, while all you really use it for is mutex semantics, I
> > think it would be a good idea to convert the driver to use the
> > actual mutex primitive; this will buy you a lot of extra automatic
> > checking for bugs...
> >
> > Greetings,
> >    Arjan van de Ven
> >
> 
> OK... here's a redone patch:
> +	unsigned long *buf = mq->recvbuf;
> +	if (mutex_trylock(&maple_keyb_mutex)) /* Can only be locked
> if already in cleanup */
> +		return;
> +	if (buf[1] == mapledev->function) {
> 

I think this has a bug; mutex_trylock has the opposite return code as
down_trylock (mutex follows the same convention as the spinlock
trylock).... so you probably need to add a ! here...

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbZJCN0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbZJCN0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZJCNZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:25:59 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:38099 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbZJCNZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:25:58 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Date: Sat, 3 Oct 2009 15:27:43 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Johan Hovold <jhovold@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20090924154023.GA27480@localhost> <20091003114229.GB605@localhost> <20091003141807.1dc27e4e@lxorguk.ukuu.org.uk>
In-Reply-To: <20091003141807.1dc27e4e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910031527.43660.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 3. Oktober 2009 15:18:07 schrieb Alan Cox:
> The generic driver is a very bad example to follow in some areas but
> this looks a big improvement. There are some patches reworking the
> generic code to use kfifo on the output side which make it vastly better.
> Not sure where the relevant google submissions went ?

They have been included into rc1.

> > -     spin_lock_irqsave(&priv->rx_lock, flags);
> > -     priv->rx_flags &= ~(THROTTLED | ACTUALLY_THROTTLED);
> > -     spin_unlock_irqrestore(&priv->rx_lock, flags);
> > +     spin_lock_irqsave(&port->lock, flags);
> > +     port->throttled = 0;
> > +     spin_unlock_irqrestore(&port->lock, flags);
>
> If you only have a single bit use the set_bit/clear_bit/test_and_xxx_bit
> stuff as it's faster on most boxes

I think we cannot do with less than two flags, whose transition has
to be atomic here.

	Regards
		Oliver


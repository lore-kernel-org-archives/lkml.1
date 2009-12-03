Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbZLCMXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbZLCMXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 07:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbZLCMXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 07:23:46 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33831 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753688AbZLCMXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 07:23:45 -0500
Date: Thu, 3 Dec 2009 12:24:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/11] pps: serial clients support.
Message-ID: <20091203122458.16bb57d2@lxorguk.ukuu.org.uk>
In-Reply-To: <20091203120523.GE12943@gundam.enneenne.com>
References: <1259774329-29663-1-git-send-email-giometti@linux.it>
	<1259774329-29663-2-git-send-email-giometti@linux.it>
	<1259774329-29663-3-git-send-email-giometti@linux.it>
	<1259774329-29663-4-git-send-email-giometti@linux.it>
	<1259774329-29663-5-git-send-email-giometti@linux.it>
	<1259774329-29663-6-git-send-email-giometti@linux.it>
	<1259774329-29663-7-git-send-email-giometti@linux.it>
	<20091202185903.66e6709e@lxorguk.ukuu.org.uk>
	<20091203105347.GB12943@gundam.enneenne.com>
	<20091203114641.391e4014@lxorguk.ukuu.org.uk>
	<20091203120523.GE12943@gundam.enneenne.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > void n_tty_init_ops(struct tty_ldisc_ops *ops)
> > {
> > 	*ops = tty_ldisc_N_TTY;
> > 	ops->owner = NULL:
> > 	ops->refcount = ops->flags = 0;
> > }
> > EXPORT_SYMBOL_GPL(n_tty_inherit_ops);
> 
> The problem is that I have to do some operations into ldisc's open and
> close methods (see linux/drivers/pps/clients/pps-ldisc.c).
> 
> By using your solution I inherit such methods but I cannot modify
> their behaviour in a manner suitable for register/deregister PPS
> support at runtime.

You can

	n_tty_init_ops(&my_ops);
	my_ops.num = whatever;
	old_open = my_ops.open;
	my_ops.open = pps_ntty_open;

etc

While not as pretty in C as C++ it works fine.

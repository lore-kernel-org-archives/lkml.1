Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbZLCMFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbZLCMFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 07:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZLCMFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 07:05:21 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:57453 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZLCMFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 07:05:21 -0500
Date: Thu, 3 Dec 2009 13:05:24 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Message-ID: <20091203120523.GE12943@gundam.enneenne.com>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
	Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Christoph Hellwig <hch@infradead.org>
References: <1259774329-29663-1-git-send-email-giometti@linux.it> <1259774329-29663-2-git-send-email-giometti@linux.it> <1259774329-29663-3-git-send-email-giometti@linux.it> <1259774329-29663-4-git-send-email-giometti@linux.it> <1259774329-29663-5-git-send-email-giometti@linux.it> <1259774329-29663-6-git-send-email-giometti@linux.it> <1259774329-29663-7-git-send-email-giometti@linux.it> <20091202185903.66e6709e@lxorguk.ukuu.org.uk> <20091203105347.GB12943@gundam.enneenne.com> <20091203114641.391e4014@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203114641.391e4014@lxorguk.ukuu.org.uk>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 06/11] pps: serial clients support.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 11:46:41AM +0000, Alan Cox wrote:

> > Again, should I remove the possibility to compile pps-ldisc as module?
> 
> It would do that yes. I hadn't considered that aspect of it - and that in
> turn would force you to compile the core PPS support in to get pps-ldisc.
> 
> How about this then (I'm trying to see a way to avoid all thsoe exports
> of functions)
> 
> /**
>  *	n_tty_inherit_ops		-	initialise ldisc ops
>  *	@ops: ops to initialise
>  *
>  *	Allow a line discipline to inherit the basic operations
>  *	from the n_tty line discipline. The caller must set up
>  *	its own ldisc number, flags and name. It must use the
>  *	inherited value of magic.
>  */
> 
> void n_tty_init_ops(struct tty_ldisc_ops *ops)
> {
> 	*ops = tty_ldisc_N_TTY;
> 	ops->owner = NULL:
> 	ops->refcount = ops->flags = 0;
> }
> EXPORT_SYMBOL_GPL(n_tty_inherit_ops);

The problem is that I have to do some operations into ldisc's open and
close methods (see linux/drivers/pps/clients/pps-ldisc.c).

By using your solution I inherit such methods but I cannot modify
their behaviour in a manner suitable for register/deregister PPS
support at runtime.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it

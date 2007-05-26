Return-Path: <linux-kernel-owner+w=401wt.eu-S1763908AbXEZQtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763908AbXEZQtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXEZQth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:49:37 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:38784 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbXEZQtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:49:36 -0400
Date: Sat, 26 May 2007 18:49:35 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.21.1] soft lockup when removing netconsole module
Message-ID: <20070526164934.GE11760@vanheusden.com>
References: <20070526154011.GB3735@vanheusden.com> <465857DF.2020603@gmail.com> <1180195927.4264.11.camel@chaos> <20070526161645.GA11760@vanheusden.com> <1180197324.4264.23.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1180197324.4264.23.camel@chaos>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sun May 27 17:52:04 CEST 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a key-signing at www.biglumber.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Seems to be hrtimers related - CC'ed Thomas.
> > > I doubt that. The tick interrupt just finds out, that the machine is
> > > stuck in rmmod.
> > > > > Also the rmmod hangs and would not exit even with kill -9. It also
> > > > > sucks up 100% cpu.
> > > Can you please enable CONFIG_PROVE_LOCKING ?
> > Luckily I already had :-)
> > Here is its output:
> So there is no output from lockdep, during the rmmod hang ? The rmmod

Nope, just other subsystems (nfs, usb) minutes before that.

> sucks 100% cpu, so it busy loops at some place. Looking at the stack
> trace this seems to be in:
> void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
>                                        struct delayed_work *dwork)
> {
>         while (!cancel_delayed_work(dwork))
>                 flush_workqueue(wq);
> }
> which is not really related to timers :)

Ok.


Folkert van Heusden

-- 

Multitail - gibkaja utilita po sledovaniju log-fajlov i vyvoda
kommand. Fil'trovanie, raskrašivanie, slijanie, vizual'noe sravnenie,
i t.d.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com

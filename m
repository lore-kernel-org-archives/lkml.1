Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbYKURiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbYKURiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661AbYKURiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:38:11 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2030 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbYKURiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:38:10 -0500
Date: Fri, 21 Nov 2008 18:38:00 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.28-rc5] RCU detected CPU 0 stall (t=4294893165/750
	jiffies)
Message-ID: <20081121173800.GS24427@vanheusden.com>
References: <20081119123717.GE24427@vanheusden.com> <49267FA4.60609@cn.fujitsu.com> <20081121094543.GP24427@vanheusden.com> <20081121151205.GA6775@linux.vnet.ibm.com> <20081121153425.GR24427@vanheusden.com> <20081121155333.GB6775@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121155333.GB6775@linux.vnet.ibm.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Thu Nov 20 11:27:06 CET 2008
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > I'm afraid there's no script for that: it happens during boot.
> > > This is a HZ=250 machine, correct?  If so, please try the following
> > > patch (already in -tip), which helps suppress boot-time false positives.
> > That's correct, 250Hz.
> > > -#define RCU_SECONDS_TILL_STALL_CHECK	( 3 * HZ) /* for rcp->jiffies_stall */
> > > +#define RCU_SECONDS_TILL_STALL_CHECK	(10 * HZ) /* for rcp->jiffies_stall */
> > Isn't it better to let the define depend on the value of CONFIG_HZ?
> > E.g.
> The stalls occur when CPUs spin in the kernel with preemption (or irqs
> or whatever) disabled.  So while I suppose that there is some
> possibility that such a spin might be a function of HZ, I have never
> seen this happen.
> The reason I asked for your HZ value was to make sure that the stall
> detection was 3 seconds (750 jiffies).  If you had been running a
> 75HZ system (admittedly unlikely) you would have seen a 10-second stall,
> and the patch would not help.  In that case, the right thing to do would
> have been to work out why the system was spinning for 10 seconds during
> boot -- tough to get a 5-second boot when the system spins for 10
> seconds coming up, right?  ;-)

That patch fixes the rcu error.

odr:/# grep -i rcu t
[    0.000000] RCU-based detection of stalled CPUs is enabled.



Folkert van Heusden

-- 
MultiTail na wan makriki wrokosani fu tan luku den logfile nanga san
den commando spiti puru. Piki puru spesrutu sani, wroko nanga difrenti
kroru, tya kon makandra, nanga wan lo moro.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com

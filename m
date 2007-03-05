Return-Path: <linux-kernel-owner+w=401wt.eu-S933266AbXCEMVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbXCEMVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933288AbXCEMVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:21:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:35842 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933266AbXCEMVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:21:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uV1Qs9zKb+TMQ0H7aiNxhmtfES420DUMZy3ivqDxUlIrVPS9HTYa2i1FXp9YGpzFEIGLHRlCgbdiPd/sSl4JBMeE8dXo0lxSpZ4wJaQlYMlFvkq510TGBCEdxWVUvdOejEFeSOkVeRlDemmKbXGZ0HzRFmWCfeDfWN33uGEQyY0=
Message-ID: <6bffcb0e0703050421l32fa68e8u3791731e4305f5b9@mail.gmail.com>
Date: Mon, 5 Mar 2007 13:21:05 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.21-rc2-git3 soft lockup detected on CPU#0 (crash dump kernel)
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <6bffcb0e0703050404h5be8d8d4i8e77e90a25150894@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1173022668.24738.141.camel@localhost.localdomain>
	 <6bffcb0e0703040847g1c04940bm4c22895ec2540bd1@mail.gmail.com>
	 <1173027823.24738.156.camel@localhost.localdomain>
	 <6bffcb0e0703040915h442b4d6cq8bb47cd961165916@mail.gmail.com>
	 <20070305080824.GA20583@elte.hu>
	 <1173090869.24738.198.camel@localhost.localdomain>
	 <20070305103141.GA18404@elte.hu>
	 <6bffcb0e0703050347j5169c672g19996d5c76707123@mail.gmail.com>
	 <20070305115111.GA10675@elte.hu>
	 <6bffcb0e0703050404h5be8d8d4i8e77e90a25150894@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> On 05/03/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> >
> > > >also below is a softlockup-debug patch that might be useful, which adds
> > > >a tick/tock output so it spams the console once per second but can show
> > > >the dynamics of lockups (and other delays).
> > >
> > > I have applied this patch
> > > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-git3-kdump/log3.txt
> >
> > thanks. It seems that the 'BUG: soft lockup detected' message does not
> > occur in this log though - and that there are bootup messages between
> > the two sysrq outputs:
> >
> > [  221.101833] skge eth1: disabling interface
> > [  228.740911] audit(1173094442.943:11): user pid=3245 uid=0
> > auid=4294967295 subj=system_u:system_r:hwclock_t:s0 msg='changing system
> > time: exe="/sbin/hwclock"
> > (hostname=?, addr=?, terminal=console res=success)'
> > [  233.148571] md: md1 in immediate safe mode
> >
> > plus there's trouble with irq 10:
> >
> > [  132.013194] irq 10: nobody cared (try booting with the "irqpoll" option)
> > [  132.072771] Disabling IRQ #10
> >
> > that prompted you to enable irqpoll, right?
>
> No. irqpoll is added by /etc/init.d/kdump script (FC6).
>
> > So am i right that without
> > irqpoll there's no lockup?
>
> I will check this.

I can confirm that without irqpoll everything works fine.
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-git3-kdump/log4.txt

irqpoll is recommended as a command line option in Documentation/kdump/kdump.txt

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbZAVVR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbZAVVR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 16:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZAVVRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 16:17:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34851 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbZAVVRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:17:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Date: Thu, 22 Jan 2009 22:17:08 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       dbrownell@users.sourceforge.net
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com> <20090120115500.GA4442@elte.hu> <c4e36d110901220714j524343c5k2673d5626aef2460@mail.gmail.com>
In-Reply-To: <c4e36d110901220714j524343c5k2673d5626aef2460@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901222217.09351.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009, Zdenek Kabelac wrote:
> 2009/1/20 Ingo Molnar <mingo@elte.hu>:
> >
> > (Cc:-ed Johannes Berg)
> >
> > * Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
> >
> >> With network enabled - the error is back - thus it might be a bug in
> >> ieee80211 stack ??
> >
> > yes, the crash implicates the ieee80211 stack [ieee80211_stop() in
> > net/mac80211/iface.c]:
> >
> >> general protection fault: 0000 [#1] SMP
> >> RIP: 0010:[<ffffffff8053ce01>]  [<ffffffff8053ce01>] wait_for_common+0x131/0x190
> >> Process NetworkManager (pid: 2265, threadinfo ffff88006b508000, task
> >> Call Trace:
> >>  [<ffffffff8025a735>] synchronize_rcu+0x35/0x40
> >>  [<ffffffff8025a620>] ? wakeme_after_rcu+0x0/0x10
> >>  [<ffffffff8053ce3f>] ? wait_for_common+0x16f/0x190
> >>  [<ffffffff8024b424>] ? local_bh_enable+0xa4/0x110
> >>  [<ffffffff804c8ce1>] ? dev_deactivate+0x151/0x1d0
> >>  [<ffffffff804b750d>] ? dev_close+0x6d/0xd0
> >>  [<ffffffffa016b042>] ? ieee80211_stop+0x562/0x570 [mac80211]
> >>  [<ffffffffa016ab59>] ? ieee80211_stop+0x79/0x570 [mac80211]
> 
> Any progress with this problem ?
> 
> Btw - I've tried your branch   tip-latest
> (52a4061e1d88ad242c8022f68df3686c3bc05159)
>  - and this branch now resets my machine during resume. (it suspends -
> auto-wake-up and reboots)
>  - so it this branch actually suggested to be used/tested ?

Apparently, it's missing the patch from
http://bugzilla.kernel.org/show_bug.cgi?id=12399

Thanks,
Rafael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbXJZR4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbXJZR4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXJZR4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:56:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36756 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbXJZR4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:56:34 -0400
Date: Fri, 26 Oct 2007 19:56:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
       Romano Giannetti <romanol@upcomillas.es>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Edward Hsu <edward_hsu@realtek.com.tw>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc1 fails with lockup - /sbin/ifconfig / inet_ioctl() /
	dev_close() / rtl8169_down()
Message-ID: <20071026175613.GA18770@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <1193232344.32208.0.camel@localhost> <20071024142759.GA13657@elte.hu> <1193241191.14314.8.camel@localhost> <20071024155521.GA16690@elte.hu> <1193242267.6914.6.camel@twins> <1193378269.17910.4.camel@localhost> <20071026063733.GA12426@elte.hu> <20071026094833.539a69aa@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026094833.539a69aa@freepuppy.rosehill>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Hemminger <shemminger@linux-foundation.org> wrote:

> > hm, from your log it appears that lockdep did not find anything, 
> > still the hang does trigger.
> > 
> > it's /sbin/ifconfig and inet_ioctl() / dev_close() / rtl8169_down() 
> > that seems to be hanging. I've extracted the relevant backtrace 
> > below. I've Cc:-ed people who might have a better idea about what's 
> > going on.
> 
> Are you building with NAPI enabled or not. Looks like the following 
> might help the non-napi case.

the config from:

  http://www.dea.icai.upcomillas.es/romano/linux/info/2624rc1_1/

suggests that NAPI was disabled:

  CONFIG_R8169=m
  # CONFIG_R8169_NAPI is not set
  CONFIG_R8169_VLAN=y

	Ingo

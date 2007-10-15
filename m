Return-Path: <linux-kernel-owner+w=401wt.eu-S1765833AbXJORjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765833AbXJORjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757752AbXJORjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:39:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757715AbXJORjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:39:04 -0400
Date: Mon, 15 Oct 2007 19:38:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Al Viro <viro@ftp.linux.org.uk>, gregkh@suse.de,
       David Brownell <dbrownell@users.sourceforge.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [build bug] drivers/ssb build failure, latest -git
Message-ID: <20071015173840.GA26109@elte.hu>
References: <20071014032948.GA25760@elte.hu> <20071014033549.GQ8181@ftp.linux.org.uk> <20071015105344.GA17028@elte.hu> <200710151458.54817.mb@bu3sch.de> <20071015135041.GB30221@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015135041.GB30221@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > > there's a new build failure with latest -git:
> > > 
> > >  drivers/built-in.o: In function `ssb_ohci_probe':
> > >  ohci-hcd.c:(.text+0xbff39): undefined reference to `ssb_device_enable'
> > >  ohci-hcd.c:(.text+0xbff6f): undefined reference to `ssb_admatch_base'
> > >  ohci-hcd.c:(.text+0xbff8b): undefined reference to `ssb_admatch_size'
> > >  ohci-hcd.c:(.text+0xbffe5): undefined reference to `ssb_device_disable'
> > >  [...]
> > > 
> > > config attached.

> > I'm not sure why this happens. SSB is Y and ohci-hcd is also Y. So 
> > why doesn't it find the syms?
> 
> hm, it builds fine now. Weird - i'll double-check i got the right 
> config.

find attached another config that reproduces the build failure above.

i think the reason is this:

CONFIG_SSB=m
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y

	Ingo

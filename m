Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYJYX4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYJYX4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 19:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYJYX4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 19:56:06 -0400
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:64934
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbYJYX4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 19:56:04 -0400
X-Trace: 186721772/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6/None/alistair@devzero.co.uk
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-MUA: KMail/1.10.1 (Linux/2.6.27-damocles; KDE/4.1.2; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEALNOA0nDlSwG/2dsb2JhbACBdr5jg08
X-IronPort-AV: E=Sophos;i="4.33,486,1220223600"; 
   d="scan'208";a="186721772"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: r8169 MAC addresses broken
Date: Sun, 26 Oct 2008 00:55:59 +0100
User-Agent: KMail/1.10.1 (Linux/2.6.27-damocles; KDE/4.1.2; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Edward Hsu <edward_hsu@realtek.com.tw>,
       Ivan Vecera <ivecera@redhat.com>
References: <490380C8.6070003@simon.arlott.org.uk> <4903947A.3060206@gmail.com> <20081025223443.GA30913@electric-eye.fr.zoreil.com>
In-Reply-To: <20081025223443.GA30913@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810260055.59783.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 October 2008 23:34:43 Francois Romieu wrote:
> Jiri Slaby <jirislaby@gmail.com> :
> [...]
>
> > Ah, I thought I have broken hardware. I have similar problem, my mac is
> > initially all zeroes. When I set it up, it works until suspend. After
> > that I need to unbind the driver, bind it again, and it works then (mac
> > is still the set one).
> >
> > I'm out of the notebook right now, but it is 10ec:8168:
> > 06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> > RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
> > 	Subsystem: ASUSTeK Computer Inc. Unknown device 11f5
> >
> > I used it perfectly far later than 2.6.24 (maybe 2.6.26?), 2.6.27 is yet
> > defunct.
>
> 2.6.27 proper ? That's bad news.

Just thought I'd chime in to report the same thing. I don't use the NICs very
frequently, so I didn't notice until I read the report.

On this machine, the NICs are never put through a suspend/resume cycle, so
that doesn't seem to be anything to do with it.

The NICs should have incremental MAC addresses, since they're mainboard
devices. Put it this way, they used to.

Now when they're detected, one has the correct MAC, and the second has the
first 32bits of its MAC corrupted.

eth0: RTL8169sc/8110sc at 0xffffc2000001e000, 00:50:8d:b3:5f:de, XID 18000000 IRQ 23                                                          
eth1: RTL8169sc/8110sc at 0xffffc20000070000, d8:81:ec:10:5f:df, XID 18000000 IRQ 22

d8:81:ec:10 is corruption; 00:50:8d:b3 is correct.

I can bisect pretty easily if this is helpful.

-- 
Cheers,
Alistair.

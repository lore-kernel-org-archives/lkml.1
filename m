Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbXEZFAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbXEZFAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 01:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbXEZFAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 01:00:32 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44339
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbXEZFAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 01:00:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 07:00:28 +0200
User-Agent: KMail/1.9.5
Cc: Maximilian Engelhardt <maxi@daemonizer.de>, linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20070524195616.234280@gmx.net> <200705252048.11931.maxi@daemonizer.de> <200705252140.22635.uwe.bugla@gmx.de>
In-Reply-To: <200705252140.22635.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705260700.28777.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2007 21:40, Uwe Bugla wrote:
> Am Freitag, 25. Mai 2007 20:48 schrieben Sie:
> > On Fri, 25 May 2007 17:59:29 +0200, Uwe Bugla wrote:
> > > Perhaps someone reading this could try to reproduce that problem on his
> > > machine.
> > > Now who of the readers owes a Broadcom 4401 NIC and can please try to
> > > test kernel 2.6.22-rc2-mm1?
> > >
> > > Those NICs have been used very very often as onboard controllers,
> > > especially on ASUS boards.
> >
> > I've been using 2.6.22-rc2 for some time and now I compiled 2.6.22-rc2-
> > mm1 and both work fine with the BCM4401 in my laptop.
> >
> > Maxi
> 
> Hello Maxi,
> 
> That may be true for your Laptop, but it unfortunately isn't true for my ASUS 
> mainboard onboard controller.
> 
> Unfortunately I cannot confirm this:
> 
> My broadcom 4401 driver is not part of a notebook, but instead part of an ASUS 
> P4PE mainboard.
> 
> At my second attempt I went the conventional path (i. e. ignoring the fact 
> that
> "Broadcom 4400 ethernet support appears twice in section "Network device 
> support":
> 
> Whether you leave out "EISA, VLB, PCI and on board controllers" or not it 
> simply appears twice in kernel config! This is bug number 1.

No it is NOT a bug.
It simply shows again that you don't know how b44, ssb or anything related works.

Would you _please_ take a look at the code, before calling features bugs.
And yes, this IS a feature. It is a feature to get b44 running on an OpenWRT
embedded device. These devices don't have a PCI bus. So b44 MUST NOT depend
on "EISA, VLB, PCI and on board controllers".
"Broadcom 4400 PCI device support" does depend on "EISA, VLB, PCI and on board controllers".

Everything is correct.
Bug number 1 is solved.
qed

> This time I do get a "good" interrupt: IRQ 21 for the the device.
> 
> BUT:
> 
> Trying to ping another machine fails saying:
> 
> "destination host unreachable"
> 
> 
> That means, Although the interrupt is fine now, the device is still not 
> functionable.

And it's completely impossible that you did a mistake when configuring
the device? Typo in the IP? Typo in the gateway or DNS entries?
Try it again, please.
And please try with current wireless-dev tree.

And I simply do not get it why you suddenly get a good IRQ number, like everybody
else does, without fixing The Bug (tm).

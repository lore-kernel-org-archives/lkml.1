Return-Path: <linux-kernel-owner+w=401wt.eu-S938175AbXGSKcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938175AbXGSKcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937260AbXGSKLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:11:11 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:10999 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S936852AbXGSKLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:11:09 -0400
X-Nifty-SrcIP: [220.219.61.77]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=vvhUPxnJHqeTpaWMhen5O9x+ZXvNpnKErL4TUhFY8IYfvsNeTay3YLRjmU6ZSQNiL7zZ2XlmTjcBQcToV2k1yg==  ;
Date: Thu, 19 Jul 2007 19:08:31 +0900 (JST)
Message-Id: <20070719.190831.23015057.takada@mbf.nifty.com>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, teheo@novell.com
Subject: Re: i386: pata_cs5520 does not work
From: TAKADA Yoshihito <takada@mbf.nifty.com>
In-Reply-To: <20070719015806.8B09.TAKADA@mbf.nifty.com>
References: <20070716.091928.111205836.takada@mbf.nifty.com>
	<20070718144212.3289e86c@the-village.bc.nu>
	<20070719015806.8B09.TAKADA@mbf.nifty.com>
X-Mailer: Mew version 5.1 on Emacs 22.1.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: TAKADA Yoshihito <takada@mbf.nifty.com>
Subject: Re: i386: pata_cs5520 does not work
Date: Thu, 19 Jul 2007 02:20:39 +0900

Hi. I found it return from cs5520_init_one();
devm_request_irq() is failed.

> rc = devm_request_irq(&pdev->dev, irq[ap->port_no],
> 	ata_interrupt, 0, DRV_NAME, host);

devm_request_irq() is called twice from loop.
In 1st time, ap->port_no is 0. devm_request_irq() is success.
2nd time, ap->port_no is 0 too. devm_request_irq() failed.

> Hi. Thanks for reply.
> It is not issue of pata_cs5520.
> In good case, ReiserFS detects root partition.
> Bad case, ReiserFS does not detects partition.
> 
> ReiserFS: sda2: found reiserfs format "3.6" with standard journal
> 
> On Wed, 18 Jul 2007 14:42:12 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > > I'll take a look at this next week. Can you send me a dmesg of the
> > > > working case and an lspci -vvxxx
> > > 
> > > Thanks. attached 2 dmesgs(2.6.21 with pata_cs5520, 2.6.22 with IDE) and output of lspci.
> > 
> > Nothing obviously wrong. What happens if you find the line
> > 
> > if (!iomap[0] || !iomap[1] || !iomap[2] || !iomap[3] || !iomap[4])
> > 		return -ENOMEM;
> > 
> > in pata_cs5520.c and change the end from return -ENOMEM to 
> > 
> > if (!iomap[0] || !iomap[1] || !iomap[2] || !iomap[3] || !iomap[4])
> > 		panic("IO MAP");
> > 
> > This should help identify where the problem occurs
> 
> -- 
> TAKADA <takada@mbf.nifty.com>
> 
> 

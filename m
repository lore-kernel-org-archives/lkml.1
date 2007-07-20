Return-Path: <linux-kernel-owner+w=401wt.eu-S938866AbXGTAtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938866AbXGTAtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935003AbXGTAqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:46:05 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:27179 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760053AbXGTAqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:46:00 -0400
X-Nifty-SrcIP: [210.170.245.86]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=pS/zlii7qVQj/m26KqkI7EDREghpVspNTXIcu4enVe7gg5FjsGSgOUXS+QCpZLVfW+Lb63C4NJAB6jGOZbt1Ng==  ;
From: TAKADA Yoshihito <takada@mbf.nifty.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: i386: pata_cs5520 does not work
Cc: linux-kernel@vger.kernel.org, teheo@novell.com
In-Reply-To: <20070719161821.5206ac36@the-village.bc.nu>
References: <20070719.190831.23015057.takada@mbf.nifty.com> <20070719161821.5206ac36@the-village.bc.nu>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.064
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.28.01 [ja]
Message-ID: <20070720004553.15709.qmail@smb518.nifty.com>
Date: Fri, 20 Jul 2007 09:45:53 +0900
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
That's good. It seems to works fine.

On Thu, 19 Jul 2007 16:18:21 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> O> > rc = devm_request_irq(&pdev->dev, irq[ap->port_no],
> > > 	ata_interrupt, 0, DRV_NAME, host);
> > 
> > devm_request_irq() is called twice from loop.
> > In 1st time, ap->port_no is 0. devm_request_irq() is success.
> > 2nd time, ap->port_no is 0 too. devm_request_irq() failed.
> 
> Looks like whoever updated it to the new probe mechanism didn't quite get
> it right
> 
> Change it to use 
> 
>           struct ata_port *ap = host->ports[i];
> 
> not ports[0]
> 
> Alan

-- 
TAKADA <takada@mbf.nifty.com>


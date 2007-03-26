Return-Path: <linux-kernel-owner+w=401wt.eu-S933358AbXCZW0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbXCZW0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933414AbXCZW0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 18:26:00 -0400
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:34397 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933358AbXCZWZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 18:25:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xVkjp0K9/hCc2c4zkRkK2joQfN1eqFqDshXsgVNBSEoC8AsGOylPHUrynA+dusbhCE9kq6oZgX0WMkxD+Mn7gf5yreI9JOICofp/USqGzR8Bl4HVSC3SRpWKBaraZm5ghinhFyUCijl4wIdp22A65cXTPiJM/uZO2t2o3IsXwl8=  ;
X-YMail-OSG: fJa0bJUVM1kL3QRde5cK855JxrA_dhtYK6PIj0bIDVcIe24lPI3_FOBY.7CHk9lSj_tM58RJJFy2utYQJFuv_.FjhuKopMbiJWXTCg4UCnlD2dR7J1re_3k6.zK9AvvPtY.lw2klG_REaETpKee6pLkz6A--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.21-rc5 1/3] parport->dev driver model support
Date: Mon, 26 Mar 2007 15:25:56 -0700
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>
References: <200703260906.19442.david-b@pacbell.net> <20070326145942.a090d277.akpm@linux-foundation.org>
In-Reply-To: <20070326145942.a090d277.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703261525.56731.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2007 2:59 pm, Andrew Morton wrote:
> On Mon, 26 Mar 2007 09:06:19 -0700
> David Brownell <david-b@pacbell.net> wrote:
> 
> > Currently a parport_driver can't get a handle on the device node for the
> > underlying parport (PNPACPI, PCI, etc).  That prevents correct placement
> > of sysfs child nodes, which can affect things like power management.
> > 
> > This patch adds a field to "struct parport" pointing to that device node,
> > and updates non-legacy port drivers to initialize that device pointer.
> > That field replaces the analagous PCI-only support in parport_pc.
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > ---
> > NOTE this depends on an earlier patch to make pnp devices set up DMA,
> > parport is the primary user of legacy i8237 dma infrastructure.
> 
> Confusion reigns.
> 
> To which "earlier patch" do you refer?

The one named "init-dma-masks-in-pnp_dev.patch" in 2.6.21-rc4-mm1 ...


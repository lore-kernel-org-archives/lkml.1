Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbZJ0JpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbZJ0JpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 05:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZJ0JpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 05:45:16 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:8965 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbZJ0JpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 05:45:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAHNe5krCTtAn/2dsb2JhbACBUNZkhD8E
Date: Tue, 27 Oct 2009 10:45:03 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: David Miller <davem@davemloft.net>
Cc: hancockrwd@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH ide] : Increase WAIT_DRQ to support slow CF cards
Message-ID: <20091027094503.GA3116@frolo.macqel>
References: <51f3faa70910261807h54f05f73j48b67067ee3dde70@mail.gmail.com> <20091026.181922.261475236.davem@davemloft.net> <51f3faa70910261840v16444067uc323de7129b7592f@mail.gmail.com> <20091026.184318.205708741.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026.184318.205708741.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, Oct 26, 2009 at 06:43:18PM -0700, David Miller wrote:
> From: Robert Hancock <hancockrwd@gmail.com>
> Date: Mon, 26 Oct 2009 19:40:03 -0600
> 
> > On Mon, Oct 26, 2009 at 7:19 PM, David Miller <davem@davemloft.net> wrote:
> >> Meanwhile we should provide a way for things to work, and
> >> realistically the only way to do that currently is to bump the
> >> WAIT_DRQ value to some large number.
> >>
> >> And that's exactly the kind of patch I'm willing to accept for this.
> > 
> > I agree, it's sub-optimal but it helps.. if the user wants better
> > behavior they should a) fix it so that the card isn't using PIO, at
> > least if it supports DMA and b) not use drivers/ide..

Strangely enough, I also had no timeout problem if I started my kernel with
'ide=nodma', instead of increasing WAIT_DRQ.  So I surmise that WAIT_DRQ
is used in the dma case.

> 
> Philippe's patch that started this thread uses "3 * HZ / 10"
> which isn't large enough for the SSD cases.  Can someone please
> post a patch that uses a large enough value?

How big a timeout do you want/accept ? Mark Lord wrote about SSD's in the mail
referred by Robert Hancock :
	It should probably be at least 500msec or more now.

Philippe

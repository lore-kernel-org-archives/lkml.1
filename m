Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZCLEbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZCLEbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbZCLEbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:31:01 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:9212 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZCLEbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:31:00 -0400
X-IronPort-AV: E=Sophos;i="4.38,348,1233550800"; 
   d="scan'208";a="84228051"
Subject: Re: [PATCH] [net/irda]: new Blackfin on-chip SIR IrDA driver
From: gyang <graf.yang@analog.com>
To: Mike Frysinger <vapier.adi@gmail.com>
CC: graff yang <graff.yang@gmail.com>, samuel@sortiz.org,
       irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       cooloney@kernel.org
In-Reply-To: <8bd0f97a0903112123j60eab672m16177581c959453b@mail.gmail.com>
References: <1236756563-20633-1-git-send-email-graff.yang@gmail.com>
	 <8bd0f97a0903110057x46cb2aa9p43dd8e12a28be67a@mail.gmail.com>
	 <7d86d44a0903110256t11edeff5qfd21055ef047dc2a@mail.gmail.com>
	 <8bd0f97a0903110343m1f2f01catbc6cd54ecce91db9@mail.gmail.com>
	 <1236831455.21146.7.camel@dy>
	 <8bd0f97a0903112123j60eab672m16177581c959453b@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 12:30:41 +0800
Message-ID: <1236832241.21146.12.camel@dy>
MIME-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Mar 2009 04:30:54.0397 (UTC) FILETIME=[54F1E6D0:01C9A2CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 00:23 -0400, Mike Frysinger wrote:
> On Thu, Mar 12, 2009 at 00:17, gyang wrote:
> > On Wed, 2009-03-11 at 06:43 -0400, Mike Frysinger wrote:
> >> On Wed, Mar 11, 2009 at 05:56, graff yang wrote:
> >> > On Wed, Mar 11, 2009 at 3:57 PM, Mike Frysinger wrote:
> >> >> On Wed, Mar 11, 2009 at 03:29,  <graff.yang@gmail.com> wrote:
> >> >>> +static int __devinit bfin_sir_probe(struct platform_device *pdev)
> >> >>> +{
> >> >>> +       struct net_device *dev;
> >> >>> +       struct bfin_sir_self *self;
> >> >>> +       unsigned int baudrate_mask;
> >> >>> +       struct bfin_sir_port *sir_port;
> >> >>> +       int err;
> >> >>> +
> >> >>> +       err = peripheral_request_list(per[pdev->id], DRIVER_NAME);
> >> >>
> >> >> what if pdev->id is set to 12512 ?
> >> >
> >> > The pdev->id is defined in board files, for example, uart0 should be 0.
> >>
> >> so ?  what's to stop the user from setting it to 12415 ?  the driver
> >> must sanity check these things.  you can never assume platform dev
> >> resources always have valid pointers and valid values.
> >
> > How about to limit the pdev->id to be 0,1,2,3 ?
> > I can extend the per to be
> > static const unsigned short per[][4] = {
> >        {P_UART0_RX, P_UART0_TX, 0, 0},
> >        {P_UART1_RX, P_UART1_TX, 0, 1},
> >        {P_UART2_RX, P_UART2_TX, 0, 2},
> >        {P_UART3_RX, P_UART3_TX, 0, 3},
> > };
> >
> > then check (pdev->id >= 0 && pdev->id < ARRAY_SIZE(per) &&
> > per[pdev->id][3] == pdev->id)
> 
> the last check is redundant.  the first two should be added.

I'm afraid of some cases such as uart0 uses id 1, will cause driver not
work, and not any warning message.

> 
> >> >>> +       switch (max_rate) {
> >> >>> +       default:
> >> >>> +               printk(KERN_WARNING "bfin_sir: Invalid maximum baud rate, using 9600\n");
> >> >>
> >> >> dev_warn(&dev->dev,....) ?
> >> >
> >> > Here the netdev has not been registered.
> >>
> >> then use pdev->dev ?
> >
> > Don't it seem strange to mixed use dev_warn(&dev->dev, ...) and
> > dev_warn(&pdev->dev, ...) ?
> 
> not really
> 
> > And printk is enough.
> 
> printk() makes sense when a dev is not available.  we have a dev here,
> so the dev_*() funcs should be used.
> -mike

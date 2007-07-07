Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbXGGTYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbXGGTYh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 15:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXGGTY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 15:24:28 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:55224 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbXGGTY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 15:24:26 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Sun, 8 Jul 2007 01:16:17 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: KII Keiichi <k-keiichi@bx.jp.nec.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 7/9] netconsole: Support multiple logging targets
In-Reply-To: <468FDC8D.6080208@bx.jp.nec.com>
Message-ID: <Pine.LNX.4.64.0707080108240.3789@cselinux1.cse.iitk.ac.in>
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070704110814.28520.94417.sendpatchset@cselinux1.cse.iitk.ac.in>
 <468FDC8D.6080208@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 8 Jul 2007, KII Keiichi wrote:
> Hi Satyam,
> 
> The following comments aren't essential.
> 
> >  	if (!(event == NETDEV_UP || event == NETDEV_DOWN ||
> >  	      event == NETDEV_CHANGEADDR || event == NETDEV_CHANGENAME))
> > -	      	goto done;
> > +		goto done;
> 
> The above diff lines are extra.

Eek, looks like some whitespace correction leaked in here. I'll take care
not to produce the bad whitespace in the first place the first time this
line comes in.

> > +	spin_lock_irqsave(&target_list_lock, flags);
> > +	list_for_each_entry(nt, &target_list, list) {
> > +		if (nt->np.dev == dev) {
> > +			switch (event) {
> > +			case NETDEV_UP:
> > +			case NETDEV_DOWN:
> > +				nt->dev_status = net_dev_is_up(nt->np.dev);
> > +				break;
> > +
> > +			case NETDEV_CHANGEADDR:
> > +				memcpy(nt->np.local_mac, dev->dev_addr, ETH_ALEN);
> 
> The above line is over 80 characters.

Hmm, yes, but only by 2 columns. It's a simple and readable line
in its present form, so I'm not sure I'd want to be an extremist
and cut it into two ...

Satyam

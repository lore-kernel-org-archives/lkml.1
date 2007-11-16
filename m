Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbXKPJGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbXKPJGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 04:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbXKPJF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 04:05:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43092
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752619AbXKPJFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 04:05:53 -0500
Date: Fri, 16 Nov 2007 01:05:48 -0800 (PST)
Message-Id: <20071116.010548.94286711.davem@davemloft.net>
To: the.sator@gmail.com
Cc: kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org, jmorris@namei.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] net/ipv4/arp.c: Fix arp reply when sender ip 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <cac0ab7d0711160030w149c7a7s2db55ac56d0a05cc@mail.gmail.com>
References: <cac0ab7d0711151340l1cc91a2dw5ebf36e166d16d7a@mail.gmail.com>
	<20071115.152813.89410917.davem@davemloft.net>
	<cac0ab7d0711160030w149c7a7s2db55ac56d0a05cc@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jonas Danielsson" <the.sator@gmail.com>
Date: Fri, 16 Nov 2007 09:30:11 +0100

> 2007/11/16, David Miller <davem@davemloft.net>:
> > From: "Jonas Danielsson" <the.sator@gmail.com>
> > Date: Thu, 15 Nov 2007 22:40:13 +0100
> >
> > > Is there a reason that the target hardware address isn't the target
> > > hardware address?
> >
> 
> 
> > Because of this, in cases where a choice can be made Linux will
> > advertise what is most likely to result in successful communication.
> >
> > This is likely why we are changing that target address to the one of
> > the interface actually sending back the reply rather than the zero
> > value you used.
> >
> > In fact I think this information can be useful to the sender of
> > the DAD request.
> >
> 
> There seem to be some confusion about what my patch really does. It
> does not set the hardware address to a zero value.

I knew you were talking about the IP address not the hardware
address.

> The reply from the Linux kernel in computer A, before the patch would look like:
> 
> Reply:
> Opcode: reply (0x0002)
> Sender HW: 00:AA.00:AA:00:AA
> Sender IP:   192.168.0.1
> Target HW:  00:AA:00:AA:00:AA
> Target IP:    192.168.0.1

And this is exactly a sensible response in my opinion.

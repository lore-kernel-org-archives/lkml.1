Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbYF0Ja5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbYF0Ja5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 05:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYF0Jar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 05:30:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47323
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752180AbYF0Jaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 05:30:46 -0400
Date: Fri, 27 Jun 2008 02:30:46 -0700 (PDT)
Message-Id: <20080627.023046.193703830.davem@davemloft.net>
To: kotlakiran@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: setting ICSK_CA_PRIV_SIZE larger than 16 * sizeof(u32)
From: David Miller <davem@davemloft.net>
In-Reply-To: <965f530d0806270137y19c36638yc6ae0a1d4bfa63e7@mail.gmail.com>
References: <965f530d0806270137y19c36638yc6ae0a1d4bfa63e7@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kiran Kotla" <kotlakiran@gmail.com>
Date: Fri, 27 Jun 2008 03:37:59 -0500

[ Changed linux-net to netdev.  linux-net is for user questions,
  netdev is for development discussion... ]

> The only other option we have to get the kernel running with our
> protocol is to reduce the number of private variables and this is not
> possible without affecting the behavior of our protocol.

I severely doubt this.  25 32-bit state variables is just way
over the top.

Don't give up so easily.  Maybe some values can be 16-bit instead
of 32-bit.

Perhaps pairs of two odd-sized values can be encoded into a single
32-bit (one is 7 bits, the other is <= 25 bits).

Get creative.

I'm going to be very much an asshole about making that blob any
bigger, because it means every single socket in the kernel will get
bigger even if they don't use your congestion control algorithm.

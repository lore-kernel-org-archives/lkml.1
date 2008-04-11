Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbYDKA1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbYDKA1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 20:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbYDKA0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 20:26:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56021
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754605AbYDKA0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 20:26:47 -0400
Date: Thu, 10 Apr 2008 17:26:48 -0700 (PDT)
Message-Id: <20080410.172648.187059862.davem@davemloft.net>
To: lkml@rtr.ca
Cc: jesper.juhl@gmail.com, tilman@imap.cc, yoshfuji@linux-ipv6.org,
       jeff@garzik.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, xemul@openvz.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <47FEADCB.7070104@rtr.ca>
References: <9a8748490804101509l5d043ff8w565dc44dfeaf0072@mail.gmail.com>
	<20080410.154651.101700010.davem@davemloft.net>
	<47FEADCB.7070104@rtr.ca>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Lord <lkml@rtr.ca>
Date: Thu, 10 Apr 2008 20:16:11 -0400

> [c67499c0e772064b37ad75eb69b28fc218752636 is first bad commit
> commit c67499c0e772064b37ad75eb69b28fc218752636
> Author: Pavel Emelyanov <xemul@openvz.org>
> Date:   Thu Jan 31 05:06:40 2008 -0800
> 
>     [NETNS]: Tcp-v4 sockets per-net lookup.
> 
>     Add a net argument to inet_lookup and propagate it further
>     into lookup calls. Plus tune the __inet_check_established.
> 
>     The dccp and inet_diag, which use that lookup functions
>     pass the init_net into them.
> 
>     Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks Mark.

Pavel can you take a look?  I suspect that the namespace
changes or gets NULL'd out somehow and this leads to the
resets because the socket can no longer be found.  Perhaps
it's even a problem with time-wait socket namespace
propagation.

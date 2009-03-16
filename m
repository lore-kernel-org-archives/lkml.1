Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbZCPIiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbZCPIiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 04:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZCPIih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 04:38:37 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:42023 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753135AbZCPIig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 04:38:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fkTKaqYPO8OvIiLTip0/Neifs+TBH07dj4C76IUnhtpm4UBnlXA7DpkUcy9yn/b6BgvyPI6NCCeIJMhgopUSSjgvQw+WVAhvUxlfaVHsIpk4duW3wk3l9Row/COqjiaaL/PwoClTLPaA0RFWdZkk0J+0JPrL7EYk56TlC3nXK1s=  ;
X-YMail-OSG: S5R3hwgVM1mJQyCa9zqbPbNcvyWV.gboSGNUWOYNyMWTAmu9eu1MXJt0caQGxVhc4cG2GRUcd7U5Ts4_S.Z8pnaFACMSij9riJZHZDKMx08rr38xdcSv3yVeXkZr4hAqTUfJezQ396MDxtz.zgSnaMjZttuy2E.U.H3i.DqAC0J3uMFjXC2EwYTukzLU
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: yann.poupet@free.fr
Subject: Re: [PROBLEM]: potential unaligned memory access in drivers/usb/gadget/rndis.c
Date: Mon, 16 Mar 2009 01:38:32 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Harvey Harrison <harvey.harrison@gmail.com>,
       netdev@vger.kernel.org
References: <3848726.1723791236775868071.JavaMail.root@spooler2-g27.priv.proxad.net> <20090311235119.f4609775.akpm@linux-foundation.org>
In-Reply-To: <20090311235119.f4609775.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903160138.32964.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Andrew Morton wrote:
> 
> > It happened to me that skb_pull() returns a pointer to a
> > location not aligned on a 4 bytes boundary. 

Does this arch set NET_IP_ALIGN appropriately?

If worst comes to worst, use put_unaligned() instead of
a static (non-const) template for that header.



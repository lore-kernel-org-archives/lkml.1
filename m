Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYH2Pnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYH2Pnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbYH2PnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:43:23 -0400
Received: from mail.vyatta.com ([216.93.170.194]:57437 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285AbYH2PnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:43:21 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.681
Date: Fri, 29 Aug 2008 08:43:18 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <andi@firstfloor.org>,
       Joe Malicki <jmalicki@metacarta.com>,
       David Miller <davem@davemloft.net>, johnpol@2ka.mipt.ru,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       juhlenko@akamai.com, sammy@sammy.net
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Message-ID: <20080829084318.04f0fad8@extreme>
In-Reply-To: <200808282255.29640.denys@visp.net.lb>
References: <20080827.201020.17601834.davem@davemloft.net>
	<200808282225.57535.denys@visp.net.lb>
	<48B6FE6C.4080905@cosmosbay.com>
	<200808282255.29640.denys@visp.net.lb>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 22:55:29 +0300
Denys Fedoryshchenko <denys@visp.net.lb> wrote:

> On Thursday 28 August 2008, Eric Dumazet wrote:
> > OK, please try oprofile with call graph analysis.
> I did already. Even because most of programs (except ripd/zebra) can be 
> killed, and i kill them, it doesn't change almost anything.
> 
> it seems heavy things causing instability:
> 
> 1)HTB (resolution can be lowered to improve performance, i will try Jarek 
> patch soon)

If you are doing HTB it also calls clock to get timing information.
Each packet dequeue in htb calls psched_get_time() and that becomes
another call nano-second real time clock.

If your embedded processor has really expensive clock, you probably
just want to provide an alternative cheaper time source with less
resolution.


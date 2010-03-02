Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0CBOCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:02:37 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:53309 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753075Ab0CBOCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:02:36 -0500
Date: Tue, 2 Mar 2010 17:02:33 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gopalpet-B05799 <B05799@freescale.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
       Martyn Welch <martyn.welch@ge.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, davem@davemloft.net
Subject: Re: Gianfar driver failing on MPC8641D based board
Message-ID: <20100302140233.GA14488@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100226031452.GA11319@oksana.dev.rtsoft.ru>
 <4B87B937.6010204@ge.com>
 <20100226143532.GA31622@oksana.dev.rtsoft.ru>
 <4B87E01E.4070704@windriver.com>
 <4B87E662.3080106@ge.com>
 <4B87E9EF.3010604@ge.com>
 <20100226161058.GA22954@oksana.dev.rtsoft.ru>
 <4B87F67E.5070601@windriver.com>
 <20100226213825.GA32363@oksana.dev.rtsoft.ru>
 <9F4C7D19E8361D4C94921B95BE08B81BC93EC3@zin33exm22.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9F4C7D19E8361D4C94921B95BE08B81BC93EC3@zin33exm22.fsl.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sat, Feb 27, 2010 at 11:05:32AM +0530, Kumar Gopalpet-B05799 wrote:
[...]
> Understood, and thanks for the explanation. Am I correct in saying that
> this is
> due to the out-of-order execution capability on powerpc ?

Nope, that was just a logic issue in the driver. 

Though, with the patch, the eieio() is needed so that compiler (or CPU)
won't reorder lstatus and skbuff writes.

> I have one more question, why don't we use use atomic_t for num_txbdfree
> and
> completely  do away with spin_locks in gfar_clean_tx_ring() and
> gfar_start_xmit().
> In an non-SMP, scenario I would feel there is absolutely no requirement
> of spin_locks
> and in case of SMP atomic operation would be much more safer on powerpc
> rather than spin_locks.
> 
> What is your suggestion ?

I think that's a good idea.

However, in start_xmit() we'll have to keep the spinlock anyway
since it also protects from gfar_error(), which can modify
regs->tstat.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

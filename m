Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0CLI7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:59:49 -0500
Received: from mail-px0-f198.google.com ([209.85.216.198]:65487 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab0CLI7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:59:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CeGTXtXbs35mhAbWG02y8UZtmkHPZnfDbRPAqwnugpk4roWBWuHCsSyIBDws242OsK
         nB5k/AulcYkk69lJfV98QFGuiCGLPmB0FgolRcvfb2IwBaajYx2M87KxEPmPAwrKPmpb
         ZKrIbaNzH9r6S4brBoAHReCOeR7eY18Nu4lVQ=
MIME-Version: 1.0
In-Reply-To: <20100312.000705.225033546.davem@davemloft.net>
References: <20100311134556.GA6344@linux.vnet.ibm.com>
	 <20100311161751.GA3804@hack>
	 <2375c9f91003112356g1b4164e4pb5f63f0e0e2f310a@mail.gmail.com>
	 <20100312.000705.225033546.davem@davemloft.net>
Date: Fri, 12 Mar 2010 16:59:33 +0800
Message-ID: <2375c9f91003120059g771d162fxefc21beb2ab17b4d@mail.gmail.com>
Subject: Re: 2.6.34-rc1: rcu lockdep bug?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 4:07 PM, David Miller <davem@davemloft.net> wrote:
> From: Américo Wang <xiyou.wangcong@gmail.com>
> Date: Fri, 12 Mar 2010 15:56:03 +0800
>
>> Ok, after decoding the lockdep output, it looks like that
>> netif_receive_skb() should call rcu_read_lock_bh() instead of rcu_read_lock()?
>> But I don't know if all callers of netif_receive_skb() are in softirq context.
>
> Normally, netif_receive_skb() is invoked from softirq context.
>
> However, via netpoll it can be invoked essentially from any context.
>
> But, when this happens, the networking receive path makes amends such
> that this works fine.  That's what the netpoll_receive_skb() check in
> netif_receive_skb() is for.  That check makes it bail out early if the
> call to netif_receive_skb() is via a netpoll invocation.
>

Oh, I see. This means we should call rcu_read_lock_bh() instead.
If Paul has no objections, I will send a patch for this.

Thanks much, David!

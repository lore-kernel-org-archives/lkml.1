Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab0CMF2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 00:28:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42624 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab0CMF2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 00:28:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=bPzXDrPLrWXh0s6xvLhZcLCvlcvcZmGWsvZLEifAU9E3ZIXIvOzyWQvbo056cQmeks
         ggriC1jgIOMq82XOm0keOVNzgMjw/yHpJF0Dmf0UOWKszT2LgfTGh2yiVCTYo0TclT+3
         LqW08mRjJf4WuWxsfxpOyu7OxORwRuROTm9GQ=
Date: Sat, 13 Mar 2010 13:31:28 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       David Miller <davem@davemloft.net>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.34-rc1: rcu lockdep bug?
Message-ID: <20100313053128.GB3704@hack>
References: <20100311134556.GA6344@linux.vnet.ibm.com> <20100311161751.GA3804@hack> <2375c9f91003112356g1b4164e4pb5f63f0e0e2f310a@mail.gmail.com> <20100312.000705.225033546.davem@davemloft.net> <2375c9f91003120059g771d162fxefc21beb2ab17b4d@mail.gmail.com> <1268392276.3141.4.camel@edumazet-laptop> <2375c9f91003120511j6f33592cl12cb2617a27351ec@mail.gmail.com> <20100312220319.GC7824@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100312220319.GC7824@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 02:03:19PM -0800, Paul E. McKenney wrote:
>On Fri, Mar 12, 2010 at 09:11:02PM +0800, Américo Wang wrote:
>> On Fri, Mar 12, 2010 at 7:11 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> > Le vendredi 12 mars 2010 à 16:59 +0800, Américo Wang a écrit :
>> >> On Fri, Mar 12, 2010 at 4:07 PM, David Miller <davem@davemloft.net> wrote:
>> >> > From: Américo Wang <xiyou.wangcong@gmail.com>
>> >> > Date: Fri, 12 Mar 2010 15:56:03 +0800
>> >> >
>> >> >> Ok, after decoding the lockdep output, it looks like that
>> >> >> netif_receive_skb() should call rcu_read_lock_bh() instead of rcu_read_lock()?
>> >> >> But I don't know if all callers of netif_receive_skb() are in softirq context.
>> >> >
>> >> > Normally, netif_receive_skb() is invoked from softirq context.
>> >> >
>> >> > However, via netpoll it can be invoked essentially from any context.
>> >> >
>> >> > But, when this happens, the networking receive path makes amends such
>> >> > that this works fine.  That's what the netpoll_receive_skb() check in
>> >> > netif_receive_skb() is for.  That check makes it bail out early if the
>> >> > call to netif_receive_skb() is via a netpoll invocation.
>> >> >
>> >>
>> >> Oh, I see. This means we should call rcu_read_lock_bh() instead.
>> >> If Paul has no objections, I will send a patch for this.
>> >>
>> >
>> > Nope, its calling rcu_read_lock() from interrupt context and it should
>> > stay as is (we dont need to disable bh, this has a cpu cost)
>> >
>> 
>> Oh, but lockdep complains about rcu_read_lock(), it said
>> rcu_read_lock() can't be used in softirq context.
>> 
>> Am I missing something?
>
>Hmmm...  It is supposed to be OK to use rcu_read_lock() in pretty much
>any context, even NMI.  I will take a look.
>

Thanks! Please let me know if you have new progress.

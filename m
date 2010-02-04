Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab0BDAxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:53:38 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42191 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0BDAxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:53:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H17nLZp14xKZZ07Adp/ioBGt6x2LAcgzXCG93TlhHriQzMOy5hjGJ1hUJyw/Vy//uM
         GIg8n4WMp3NHZycEKijQR/eGhzvpBYC7CbjTSa7YiNZK8Zpi61ahWF1fJWJmb7MUVcOE
         fisJ0e+cuZE96pUUOtZeQrMV/J24hoBIpHrCI=
Date: Thu, 4 Feb 2010 01:53:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu] v2 accelerate grace period if last
	non-dynticked CPU
Message-ID: <20100204005327.GJ5068@nowhere>
References: <20100128153249.GA7087@linux.vnet.ibm.com> <20100131192343.GB5224@nowhere> <20100201042404.GD6721@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201042404.GD6721@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 08:24:04PM -0800, Paul E. McKenney wrote:
> There is nothing illegal about the following:
> 
> 	static void my_rcu_callback(struct rcu_head *rcu)
> 	{
> 		struct foo *fp = container_of(rcu, struct foo, rcu_head);
> 
> 		if (fp->refcnt != 0) {
> 			call_rcu(rcu);
> 			return;
> 		}
> 		kfree(fp);
> 	}
> 
> And allowing RCU_NEEDS_CPU_FLUSHES of infinity would work correctly in
> some sense, but would be a massive power inefficiency.
> 
> The choice of "5" allows a callback that posts one other callback,
> which happens often enough to be worth the extra iterations.  It is
> necessary to budget two passes through the loop per level of RCU
> callback, one for the current CPU to start the grace period and another
> for it to end it.
> 
> Seem reasonable?


Yeah ok, I did not considered situations like the above example.

Thanks.


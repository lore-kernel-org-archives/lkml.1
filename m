Return-Path: <linux-kernel-owner+w=401wt.eu-S937413AbZDJQyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937413AbZDJQyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937084AbZDJQxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:53:39 -0400
Received: from mail.vyatta.com ([76.74.103.46]:44963 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937145AbZDJQxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:53:37 -0400
Date: Fri, 10 Apr 2009 09:52:46 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Jan Engelhardt <jengelh@medozas.de>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Roman Mindalev <r000n@r000n.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: iptables very slow after
 commit784544739a25c30637397ace5489eeb6e15d7d49
Message-ID: <20090410095246.4fdccb56@s6510>
In-Reply-To: <Pine.LNX.4.64.0904101656190.2093@boston.corp.fedex.com>
References: <Pine.LNX.4.64.0904101656190.2093@boston.corp.fedex.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 17:15:52 +0800 (SGT)
Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> 
> 
> Adding 200 records in iptables took 6.0sec in 2.6.30-rc1 compared to 
> 0.2sec in 2.6.29. I've bisected down this commit.
> 
> There are a few patches on top of the original patch. When I reverted the 
> original commit + changing rcu_read() to rcu_read_bh(), it speeds up the 
> inserts back to .2sec again.
> 
> I'm loading all the firewall rules during boot-up and this 6 secs slowness 
> is really not very nice to wait for.

The performance benefit during operation is more important. The load
time is fixable. The problem is probably generic to any set of rules,
but could you post some info about your configuration (like the rule
set), and the system configuration (# of cpu's, config etc).

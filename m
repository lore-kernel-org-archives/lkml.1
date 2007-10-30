Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbXJ3OJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbXJ3OJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 10:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbXJ3OIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 10:08:54 -0400
Received: from stinky.trash.net ([213.144.137.162]:61807 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbXJ3OIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 10:08:53 -0400
Message-ID: <47273A5C.7040909@trash.net>
Date: Tue, 30 Oct 2007 15:06:20 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, rusty@au1.ibm.com,
       zhaojingmin@users.sourceforge.net, davem@davemloft.net
Subject: Re: [PATCH] nf_nat_h323.c unneeded rcu_dereference() calls
References: <20071029210618.GA4200@linux.vnet.ibm.com>
In-Reply-To: <20071029210618.GA4200@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Hello!
> 
> While reviewing rcu_dereference() uses, I came across a number of cases
> where I couldn't see how the rcu_dereference() helped.  One class of
> cases is where the variable is never subsequently dereferenced, so that
> patches like the following one would be appropriate.
> 
> So, what am I missing here?


Nothing, it was mainly intended as documentation that the hooks are
protected by RCU. I agree that its probably more confusing this way
since we're not even in a rcu_read_lock protected section.

I've queued a patch to remove them all.

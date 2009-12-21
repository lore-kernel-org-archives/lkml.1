Return-Path: <linux-kernel-owner+w=401wt.eu-S1750956AbZLUDVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956AbZLUDVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 22:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbZLUDVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 22:21:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55561 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZLUDVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 22:21:11 -0500
Date: Mon, 21 Dec 2009 04:21:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] [0/11] SYSCTL: Use RCU to avoid races with string
	sysctls
Message-ID: <20091221032104.GB25372@basil.fritz.box>
References: <20091221220.243954235@firstfloor.org> <m1eimpm6hs.fsf@fess.ebiederm.org> <20091221020427.GA25372@basil.fritz.box> <m17hshjbwk.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17hshjbwk.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So we have sysctl have locking problems, not new sysctl regressions.

Ok.

> > If the strings were made a bit smaller this could be also 
> > put on the stack, but I didn't dare for 256 bytes. 
> 
> Hmm.  rcu wise that sounds wrong, but I haven't looked into your

What sounds wrong? 

The reason for the copies is that when the reader sleeps 
rcu_read_lock() cannot be used to protect the string completely,
so it copies instead.

The alternative would have been to use SRCU, but I didn't like that.

> cool new data structure yet.

It's not really particularly new or cool, it's just a simple RCU wrapper
around a string.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

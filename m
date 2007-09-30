Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbXI3IoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbXI3IoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 04:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbXI3IoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 04:44:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:33377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbXI3IoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 04:44:10 -0400
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Date: Sun, 30 Sep 2007 10:42:25 +0200
User-Agent: KMail/1.9.1
Cc: casey@schaufler-ca.com, torvalds@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org>
In-Reply-To: <20070930011618.ccb8351b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709301042.26473.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> - Smack.txt and the website seem a bit skimpy.  Is there enough
>   documentation out there for someone to usefully (and, more importantly,
>   safely) start using smack?

Yes that's the important thing.

> - In his review of version 1, Andi suggested that your ruleset traversal
>   be protected by RCU.  But it seems that this wasn't done.  Were the races
>   which he identified fixed by other means?  If so, what were they?

The issue was moot because rulesets never get removed in the current 
implementation. I had missed that. If that ever changes RCU would be likely 
needed though.

> - hm, netlabels.  Who might be a suitable person to review that code?
>   Seems that Paul Moore is the man.  Maybe he'd be interested in taking a
>   look over it (please?)

I personally consider these IP options it uses to be pretty useless. Who could 
ever use that without cryptographic authentication? Clearly when they 
were designed in the original IP spec long ago the designers didn't understand
network security very well because the whole field was at its infancy. And 
CIPSO doesn't solve any of these fundamental issues.

It assumes a trusted network which is a very dangerous assumption.  I don't 
think that was in the original patch I looked at, I surely would have 
objected to it.

Perhaps take the network part out? I guess SMACK would be useful
locally even without questionable network support.

-Andi

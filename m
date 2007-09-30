Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbXI3RPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbXI3RPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbXI3ROw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:14:52 -0400
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:24977 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755617AbXI3ROv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:14:51 -0400
X-YMail-OSG: vBmuGIMVM1k8qMhx461fKiYjrkQPALm5I13IbaYB_QlLgv9p8jei1sUEefbeP7.CywEeFh4Zdw--
X-RocketYMMF: rancidfat
Date: Sun, 30 Sep 2007 10:14:50 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: casey@schaufler-ca.com, torvalds@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>
In-Reply-To: <200709301042.26473.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <984405.24264.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andi Kleen <ak@suse.de> wrote:

> 
> > - Smack.txt and the website seem a bit skimpy.  Is there enough
> >   documentation out there for someone to usefully (and, more importantly,
> >   safely) start using smack?
> 
> Yes that's the important thing.
> 
> > - In his review of version 1, Andi suggested that your ruleset traversal
> >   be protected by RCU.  But it seems that this wasn't done.  Were the races
> >   which he identified fixed by other means?  If so, what were they?
> 
> The issue was moot because rulesets never get removed in the current 
> implementation. I had missed that. If that ever changes RCU would be likely 
> needed though.
> 
> > - hm, netlabels.  Who might be a suitable person to review that code?
> >   Seems that Paul Moore is the man.  Maybe he'd be interested in taking a
> >   look over it (please?)
> 
> I personally consider these IP options it uses to be pretty useless. Who
> could 
> ever use that without cryptographic authentication? Clearly when they 
> were designed in the original IP spec long ago the designers didn't
> understand
> network security very well because the whole field was at its infancy. And 
> CIPSO doesn't solve any of these fundamental issues.

Real quickly, CIPSO doesn't try to. CIPSO attaches attribute information
to the packet, and that's it. Smack uses CIPSO because it's available
and sufficient to get the required information about packets from one
task to another inside the box. It does the job going off box, too.
The authentication issues are very real, but a separate issue.

> It assumes a trusted network which is a very dangerous assumption.  I don't 
> think that was in the original patch I looked at, I surely would have 
> objected to it.
>
> Perhaps take the network part out? I guess SMACK would be useful
> locally even without questionable network support.

That would break sockets. I really doubt that you're suggesting that
cryptographic authentication is required on the loopback interface.


Casey Schaufler
casey@schaufler-ca.com

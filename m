Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbXH1GbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbXH1GbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbXH1GbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:31:15 -0400
Received: from mx1.suse.de ([195.135.220.2]:43156 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbXH1GbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:31:14 -0400
From: Neil Brown <neilb@suse.de>
To: "Janne Karhunen" <janne.karhunen@gmail.com>
Date: Tue, 28 Aug 2007 16:31:08 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18131.49452.211244.327585@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NFSv3 lock recovery
In-Reply-To: message from Janne Karhunen on Tuesday August 28
References: <24c1515f0708272322h2875ea28k7a28b8651513132a@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday August 28, janne.karhunen@gmail.com wrote:
> Hi,
> 
> Brief question about NFSv3 lock recovery to those who might
> know - does Linux implementation (or NLM/NSM protocol)
> properly support the case in which client and server state
> change simultaneously?

If both crash, there is nothing for a client to reclaim and nothing
for a server to discard, so it is hard to see where a problem could
lie.

> 
> Reason I'm asking is that this very case is occasionally giving
> me stale locks. Given that NFSv3 server crashes it's possible
> that client 'rooting' from it crashes as well. Now, once the
> server comes back up it tries to notify the client that just
> crashed. Hardly surprisingly, this notification doesn't go
> anywhere and server discards the notification/client. And once
> the client starts to boot again it tries to notify the server which
> instantly whines about SM_NOTIFY when no-one is being
> monitored. Thus, whole notification cycle is busted and lock
> states go haywire :/. Is this even supposed to work?
> 

More details.  What, exactly, goes "haywire"...

If your client is diskless and mounting root from the server, then it
should be mounting the root with "-o nolock" and there should be no
locking issues at all.
Possibly it mounts some other filesystems as well, and they are
mounted with locks.  But still, I cannot imagine a problem scenario.

Please explain in detail your configuration (What is mounted where and
with what options etc) and what happens (why does the client crash
just because the server crashed - it shouldn't), and what actually
fails that you expected to work.

NeilBrown

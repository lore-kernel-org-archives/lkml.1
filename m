Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZA1Ggh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZA1Ggh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 01:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZA1Gg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 01:36:28 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43547 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZA1Gg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 01:36:28 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Jan 2009 22:36:25 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Willy Tarreau <w@1wt.eu>
cc: Greg KH <gregkh@suse.de>, Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
In-Reply-To: <20090128062021.GA32360@1wt.eu>
Message-ID: <alpine.DEB.1.10.0901272226370.20262@alien.or.mcafeemobile.com>
References: <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net> <20090128003519.GA11395@suse.de> <20090128033824.GA1662@brong.net> <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com> <20090128035746.GA3351@brong.net>
 <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com> <20090128052630.GA9512@suse.de> <20090128053642.GL5038@1wt.eu> <alpine.DEB.1.10.0901272142530.20262@alien.or.mcafeemobile.com> <20090128062021.GA32360@1wt.eu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Willy Tarreau wrote:

> Davide, I know it's not you who decide. I mean, one patch was proposed
> with one arbitrary limit. I've seen it in advance too and I too thought
> it would be more than enough. Now people are reporting breakage from
> common applications which work in a funny way (I think that using epoll
> to poll for one single FD in a multi-process architecture can be called
> funny). But those people are not expected to understand the internals,
> and most likely their application's behaviour might not be more precisely
> described than "it broke since upgrade to 2.6.27.13".
> 
> I think we should accept the fact that the fix is causing problems
> for people while it was not expected to do so. One of the solutions
> would be to increase the arbitrary ratio from 1% to more than that,
> but it will still break big setups. Another solution is to accept
> that the patch provides a tunable that admins might act on to stop
> local users' nasty activities if required, but leave the limit off
> by default. And I think that's a saner approach, especially for a
> stable series.

Absolutely. There is no 100% fit solution here. Heck, if we want to remove 
the tunable altogether I'm the happiest one, but the problem with the 
pinneable memory is there.
We can decide to remove the caps in the default setup, and leave default 
setups open to the DoS. I've no problem with that (and, as we know, I 
don't decide policies).
Then sysadmins of multiuser systems will have to enforce the caps 
themselves in order to limit the potential DoS. This is probably a good 
strategy for -stable anyway.



- Davide



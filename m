Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZKCRiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZKCRiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZKCRiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:38:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbZKCRiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:38:11 -0500
Date: Tue, 3 Nov 2009 09:37:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Marcel Holtmann <marcel@holtmann.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
In-Reply-To: <43e72e890911030924n26550ee4j619a41ec016281ea@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0911030930130.31845@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>  <20091102.224957.32364226.davem@davemloft.net> <20091103065238.GE3212@core.coreip.homeip.net>  <1257232587.3420.55.camel@localhost.localdomain> <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain>
  <1257262588.3420.79.camel@localhost.localdomain> <alpine.LFD.2.01.0911030738260.31845@localhost.localdomain>  <1257264485.3420.87.camel@localhost.localdomain> <20091103162955.GA4836@elte.hu> <43e72e890911030924n26550ee4j619a41ec016281ea@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Nov 2009, Luis R. Rodriguez wrote:
> 
> How this sort of issue is dealt with is subjective and it is up to
> maintainers to deal with.

Not when they then complain when others hit the same issue several days 
later.

> Having more information on the patch and better communication about
> the issue it solved, and the issues that reverting it would have
> caused would certainly have helped maintainers make a better call at a
> regression caused by it but knowing Johannes he'd probably cook up a
> followup fix ASAP and that is exactly what he did.

He may have cooked it up, but he didn't send it to me, and he didn't even 
bother to post it as a response to people who complained about the same 
commit.

The fact that people on the wireless mailing lists may have known about 
this just makes things _worse_, I think. It shows that we really _need_ to 
go around maintainers, when not going around them seems to result in days 
of delays and total waste of time for everybody.

Btw, the reason it's likely not getting a lot of reports is not because 
people aren't hitting it, but that the symptom when you _do_ hit it tends 
to be a dead machine. If you were running X, you have no idea what 
happened. This is why "I have one NULL pointer dereference report" should 
mean "The fix needs to go upstream _now_".

(And no, as far as I can tell, it needs no suspend/resume cycle at all. I 
don't know the code very well, but as far as I can tell it just needs a 
wireless deauthentication, which easily happens if you're running 
something like NetworkManager and your wireless network may be noisy or 
weak).

				Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZAIJA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZAIJA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 04:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZAIJAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 04:00:19 -0500
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33399 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbZAIJAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 04:00:18 -0500
Message-ID: <40547.166.70.238.44.1231488906.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20090109084540.GH5038@1wt.eu>
References: <40416.166.70.238.44.1231467823.squirrel@webmail.wolfmountaingroup.com>
    <20090109064658.GG5038@1wt.eu>
    <37611.166.70.238.44.1231486566.squirrel@webmail.wolfmountaingroup.com>
    <20090109084540.GH5038@1wt.eu>
Date: Fri, 9 Jan 2009 01:15:06 -0700 (MST)
Subject: Re: [ANNOUNCE] Kernel Blocking Firewall
From: jmerkey@wolfmountaingroup.com
To: "Willy Tarreau" <w@1wt.eu>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... snip

> ipset runs in kernel too, you just add/remove entries from userspace
> without having to touch all other ones. It has no problem storing one
> million addresses and doing fast lookups on them.
>
> I'm not dismissing your work, I just think it's a duplicate effort.
>
> Also, since you're speaking about botnets, you should support automatic
> expiration of those addresses, because almost all those addresses are
> dynamic and will match a bot for a small amount of time, then match a
> normal non-infected user. One of the reasons you found 500k addresses
> might very well be because each bot appears one hundred times at different
> addresses.
>
> Willy
>
>

You should go and look at the code, 1) the window of addresses cached in
memory is designed to act as an LRU windows for the addresses stored in
the database to use less memory, so no, the in-memory only ip tables is
primitive in comparison 2) the database can just keep growing ad growing
3) the code I posted also loads the database if the system reboots, so
your applications remember all those botnet addresses 4) their is the
ability to set a timer to expire and recycle the oldest addresses (while
still remembering all of them).

>From my experience with dealing with these systems, and observation of how
RBL databases work, when an infected system gets blacklisted, it stays
that way until the user goes to the websites and requests removal.  I have
found these zombie systems tend to stay that way, and no, by default you
NEVER want to unblock them for at least 6 months.

Jeff





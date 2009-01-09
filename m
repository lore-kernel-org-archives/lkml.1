Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZAIJKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZAIJKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 04:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZAIJKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 04:10:00 -0500
Received: from 1wt.eu ([62.212.114.60]:1308 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZAIJJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 04:09:58 -0500
Date: Fri, 9 Jan 2009 10:09:56 +0100
From: Willy Tarreau <w@1wt.eu>
To: jmerkey@wolfmountaingroup.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Kernel Blocking Firewall
Message-ID: <20090109090956.GA28484@1wt.eu>
References: <40416.166.70.238.44.1231467823.squirrel@webmail.wolfmountaingroup.com> <20090109064658.GG5038@1wt.eu> <37611.166.70.238.44.1231486566.squirrel@webmail.wolfmountaingroup.com> <20090109084540.GH5038@1wt.eu> <40547.166.70.238.44.1231488906.squirrel@webmail.wolfmountaingroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40547.166.70.238.44.1231488906.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 01:15:06AM -0700, jmerkey@wolfmountaingroup.com wrote:
> You should go and look at the code, 1) the window of addresses cached in
> memory is designed to act as an LRU windows for the addresses stored in
> the database to use less memory, so no, the in-memory only ip tables is
> primitive in comparison

I was not speaking about iptables but ipset which is an iptables extension.
>From my memories, you can have addresses stored as bitmaps, where one bit
equals one address. This would lead to less than 100 kB of RAM for your
500k addresses. But I agree that the concept of the LRU cache is interesting.

> 2) the database can just keep growing ad growing
> 3) the code I posted also loads the database if the system reboots, so
> your applications remember all those botnet addresses 4) their is the
> ability to set a timer to expire and recycle the oldest addresses (while
> still remembering all of them).

IIRC, this is also supported in ipset (I just have not looked at it for a
while now).

> From my experience with dealing with these systems, and observation of how
> RBL databases work, when an infected system gets blacklisted, it stays
> that way until the user goes to the websites and requests removal.  I have
> found these zombie systems tend to stay that way, and no, by default you
> NEVER want to unblock them for at least 6 months.

This is stupid considering that most of them change their IP address every
24 hours, or at most every 7 days. This is just used to show that spam rate
drops, hiding the fact that valid mails drop for similar reasons. For your
own use, you might consider that you'll never receive mails from people
hosted at the same ISP as the bots you block, but doing this on a large
scale or for companies who do their business around e-mail is plain stupid.

I'm on a static IP, but a lot of people I know are not. It would be
unfair to block them from posting to, say, LKML just because the week
before, someone with their address had been sending spam. And no, it
does not help getting the problem solved since the only users annoyed
are not the ones with the faulty installation.

Willy


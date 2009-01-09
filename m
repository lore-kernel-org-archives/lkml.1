Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZAIDJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZAIDJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 22:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZAIDI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 22:08:57 -0500
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:57762 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZAIDI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 22:08:57 -0500
Message-ID: <40416.166.70.238.44.1231467823.squirrel@webmail.wolfmountaingroup.com>
Date: Thu, 8 Jan 2009 19:23:43 -0700 (MST)
Subject: [ANNOUNCE] Kernel Blocking Firewall 
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One of the benefits of being the target of trolls and a variety of other
malicious groups is that my servers have been subjected to non-stop denial
of service attacks, hacking, email and spam floods, and just about every
conceivable type of malicious activity someone with a computer is capable
of perpetrating.  I get thousands of spam emails a day with not less that
50 spambots every minute of every day lambasting my servers.

And I have to say, it's been a very rewarding experience from a technology
perspective.  Since I develop forensics software, this situation has never
ceased to provide me with a wonderful testing environment for my forensics
software.  It got so bad, I had to write a firewall that blocks network
traffic a lot like wikipedia does when dealing with malicious bots and
this firewall is interactive with postfix and other apps.

One of the biggest problems of dealing with armies of spambots is even if
you use greylisting or RBL blocking, it does not stop the connection
flooding when they come back over and over and over and over.

iptables is just too cumbersome and memory comsumptive to work well and
has a shitty app inteface so I wrote one with a kernel level database and
combined it with postfix.    This firewall actually drops packets on the
floor by port, or in their entirety by IP address to deal with these
jerks.

The code is a kernel module that will build an RBL database to disk and it
will cache up to 500,000 IP addresses efficiently on a 1GB home personal
computer.  The more memory you have, the more IP addresses you can cache. 
It is configurable and possible to hold millions of them if you have 4GB
of memory in the server.

You will need one of the forenfs patches to properly patch net/core/dev.c
with the ff_filter hook.  Included is postfix-2.4.5 which I have modified
and integrated into the ff module.  My mail server uses the standard
rejection tests to determine whether or not to block an IP address FOREVER
on port 25.

ftp://ftp.wolfmountaingroup.org/pub/forenfs/patches/ffs-2.6.27.8-el5-12-11-08.patch

ftp://ftp.wolfmountaingroup.org/pub/ff/postfix/postfix-2.4.5.tar.gz
ftp://ftp.wolfmountaingroup.org/pub/ff/ff.tar.gz

It reduces the spam traffic from botnets by 98% on average since any
system identified as a bot get perma-blocked.  It's also useful if you
have folks who like to perform DOS attacks or password guessing.  The
IOCTL interface can be quickly integrated into just about any app quickly,
giving you the power to be a Wikipedia-style admin with your network
traffic and either block by port or ban, and its a lot faster and more
flexible than the iptables netfilter interface.

This software is designed specifically for active blocking with email
programs and other servers.

Enjoy,

Jeff



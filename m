Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbYFNHOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbYFNHOl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 03:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYFNHO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 03:14:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47496
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbYFNHO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 03:14:28 -0400
Date: Sat, 14 Jun 2008 00:14:28 -0700 (PDT)
Message-Id: <20080614.001428.26649070.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080614062758.GA23803@elte.hu>
References: <20080612.211959.52937006.davem@davemloft.net>
	<20080614060320.GA18454@elte.hu>
	<20080614062758.GA23803@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 14 Jun 2008 08:27:58 +0200

> just to clarify the bug pattern: the box was still accessible after the 
> warning. So this is a far less serious problem and i'd suggest we open 
> up a separate regression entry for it and consider the hung-TCP problem 
> closed. (i havent seen the hang in the last week, with either version of 
> the tcp-accept reverts)

It is a warning that just means the transmitted on the network device
stalled for an unusually long period of time.  Is your subnet flooded
when these warnings occur?  Is the remove side system wedged or at a
very high load when the message triggers?

All of these would be useful points of information to determine if
this might be normal or not.

In theory, if the remove port the device is connected to gets
extremely congested, emits a pause frame to your machine, but never
releases that pause, this (new) warning could trigger.

This warning was added by Arjan in 2.6.25 FYI in order to diagnose the
not-normal cases better.

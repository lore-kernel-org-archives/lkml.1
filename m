Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbYFSGh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbYFSGh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 02:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbYFSGhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 02:37:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47514
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755087AbYFSGhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 02:37:13 -0400
Date: Wed, 18 Jun 2008 23:37:13 -0700 (PDT)
Message-Id: <20080618.233713.87158879.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806190041080.31418@engineering.redhat.com>
References: <Pine.LNX.4.64.0806182318170.27388@engineering.redhat.com>
	<20080618.205948.107681537.davem@davemloft.net>
	<Pine.LNX.4.64.0806190041080.31418@engineering.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Thu, 19 Jun 2008 01:17:39 -0400 (EDT)

> I see ... the callee writes arguments into caller's stack frame, if it has 
> variable number of arguments. That it misdesign, the callee should write 
> registers arguments into it's own frame like on AMD64 (then this space 
> would be allocated only if needed).

The callee can do this even for non-variable argument lists.

It's like a set of pre-allocated stack slots for those incoming
argument registers when reloading under register pressure.

In my opinion it is better to put this onus on the callee because only
the callee knows if it needs to pop these values onto the stack to
alleviate register pressure.

I think it might be possible for the compiler to only use 176 bytes.
I'll take a look at the gcc sparc backend and the ABI specification
to see if this is the case.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbYDLGnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbYDLGnX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 02:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYDLGnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 02:43:14 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:52704 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbYDLGnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 02:43:13 -0400
Subject: Re: [PATCH] Replace completions with semaphores
From: Daniel Walker <dwalker@mvista.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <20080411210022.GJ11962@parisc-linux.org>
References: <20080411210022.GJ11962@parisc-linux.org>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 23:43:11 -0700
Message-Id: <1207982591.21308.333.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-11 at 15:00 -0600, Matthew Wilcox wrote:

> So does it make sense to retain the completion as a primitive
> in Linux?  On the one hand, it clearly denotes how one uses it --
> that it's initially 'locked' and becomes 'unlocked' later.  On the
> other hand, it is Yet Another Thing to be maintained; I had to
> add wait_for_completion_killable(), probably there needs to be a
> wait_for_completion_killable_timeout() too.

>From my perspective it should be keep completions , and remove
semaphores.. The problem with semaphores is the lack of a strict API,
and loose usage. I've seen a lot of "creative" locking in the kernel,
and if we allow that we're just asking for continued maintainability
problems in the code that uses semaphores. At times I've spent hours
trying to figure out what a semaphore is doing, or suppose to be doing.
If we enforce strict usage of semaphores, then we'll basically reproduce
mutex usage, and we have a generic mutex already..

Daniel



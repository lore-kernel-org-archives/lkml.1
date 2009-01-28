Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZA1R5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZA1R5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbZA1R5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:57:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48919 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbZA1R5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:57:31 -0500
Message-ID: <49809C2E.3000005@redhat.com>
Date: Wed, 28 Jan 2009 12:55:58 -0500
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: if (unlikely(...)) == unnecessary?
References: <alpine.DEB.1.10.0901272346480.20262@alien.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0901272346480.20262@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> I noticed that GCC >= 3.3 (not tried the ones before) automatically 
> branches out the "if" code (and follow-through the "else" code, if there). 
> Is that a coincidence or a rule we can rely on going forward?

That's the default behavior, but there are lots of things that can cause it to 
behave differently.  Also, not all branch predictors behave the same way, and 
some architectures use things like conditional instructions to fill their 
pipeline bubbles, so it's still generally useful to have a real compiler hint in 
fast-path code, even if it ends up being a no-op most of the time.

Most kernel code isn't so clock-cycle-critical that it needs these annotations. 
  If you're working on code that already has them, that's a good indication you 
should probably use them too, but otherwise you don't need to worry about it 
unless your code starts chewing up a lot of CPU time.

-- Chris

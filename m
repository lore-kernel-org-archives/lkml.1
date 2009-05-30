Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbZE3SvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbZE3SvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 14:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757743AbZE3SvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 14:51:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755748AbZE3SvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 14:51:02 -0400
Date: Sat, 30 May 2009 11:50:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vvscore@gmail.com
Subject: Re: [PATCH] 8250: Fix oops from setserial
Message-Id: <20090530115024.04850195.akpm@linux-foundation.org>
In-Reply-To: <20090530114632.7f101b9a@lxorguk.ukuu.org.uk>
References: <20090528130132.19582.65165.stgit@t61.ukuu.org.uk>
	<20090529205429.c9c73b19.akpm@linux-foundation.org>
	<20090530092557.57578dd5@lxorguk.ukuu.org.uk>
	<20090530014311.93577673.akpm@linux-foundation.org>
	<20090530114632.7f101b9a@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 May 2009 11:46:32 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Sure, huge numbers of drivers use the cast.
> > 
> > But I've never seen past sinnings as being a reason to continue sinning. 
> > Doing new code the right way doesn't result in worse code, and reduces
> > the chances of someone copying and pasting the wrong way.
> 
> As I said please read the rest of the driver.

I'm not the reading-averse one here :(

> It would ridiculous to have
> one dereference done differently to the rest in several thousand lines of
> code.

Actually, it would be typical.  Many many drivers which originally did
something consistently wrong have, over time, grown to contain a mix of
right and wrong.  It's one of the costs of doing things wrong.

> It's not a new driver, it's simply pasting a line from one place to
> another to update a field.

You already said all this.

Look, it's a single silly line, but there's a non-trivial point here. 
It comes up quite regularly and I always encourage people to do things
the right way rather than matching the existing wrong code.  Because,
when you think about it, there's really no merit in having consistently
wrong code.  A mix of right and wrong is better than 100% wrong.

If it results in inconsistent-looking code then that's good.  It may
result in some drive-by developer noticing the inconsistency and fixing
everything up.

Have a think about it.

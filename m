Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbYENWMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbYENWMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYENWMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:12:32 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:52339 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbYENWMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:12:31 -0400
To: corbet@lwn.net (Jonathan Corbet)
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
From: Andi Kleen <andi@firstfloor.org>
References: <20080514174955.GA515@elte.hu> <6457.1210801515@vena.lwn.net>
Date: Thu, 15 May 2008 00:11:44 +0200
In-Reply-To: <6457.1210801515@vena.lwn.net> (Jonathan Corbet's message of "Wed, 14 May 2008 15:45:15 -0600")
Message-ID: <87bq387cyn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 May 2008 22:04:44.0539 (UTC) FILETIME=[844B64B0:01C8B60E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

corbet@lwn.net (Jonathan Corbet) writes:
>
> 3: Provide a new form of cdev_add() which lets the driver indicate
>    that the BKL is not needed on open (or anything else?).  At a
>    minimum, it could just be a new parameter on cdev_add which has a
>    value of zero or FIXME_I_STILL_NEED_BKL.  Still some churn but easier
>    to script and smaller because a lot of drivers are still using
>    register_chrdev() - something else worth fixing.
>
>    A more involved form might provide a new chardev_add() which takes
>    the new char_dev_ops structure too.  Mapping between new and old
>    operations vectors would be done internally to avoid breaking older
>    drivers before they can be fixed.
>
> 4: Just find every char dev open() function and shove in lock_kernel()
>    calls, then remove the call from chrdev_open().  The disadvantage
>    here is that, beyond lots of work and churn, there's no way to know
>    which ones you missed.

In general when changing semantics drastically you should force
compile errors by renaming the respective entry point. That
has been the standard Linux method for this for years.

I've been also pondering a variant of 1, but 3 might be better.

> I kind of like the combination of 2 and 3, done in such a way that
> there's no "every driver must change" flag day.  This could be an
> interesting project, even...  Thoughts?

I doubt it will be very interesting, but it would be useful.
The goal less being to get rid of BKL in old drivers, but not 
requiring BKL in new drivers. Basically all BKL assumptions
in interfaces really should go.

-Andi

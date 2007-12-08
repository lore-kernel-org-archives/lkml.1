Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbXLHUsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbXLHUsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbXLHUsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:48:09 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:18745 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbXLHUsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:48:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=cqFjj9qMw0AYzyBfexjIStMfDNhxPDYDlkkD5YN62MDFA9YmlccASAdtQMv0g+4nsdazLJoCaAeM38m6sa4sAHArKY/jj2yF4I0UEXc2A95jY6KiiJBd7KNp1lV+PLwSYs12Ove+lgxpvljxrThQ5svJT3mHboTMb6V3Yx5GzK8=
Message-ID: <3efb10970712081248o43c19976k3bba552d835c81e7@mail.gmail.com>
Date: Sat, 8 Dec 2007 21:48:05 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: lockdep problem conversion semaphore->mutex (dev->sem)
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Daniel Walker" <dwalker@mvista.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Dave Chinner" <dgc@sgi.com>
In-Reply-To: <20071208200801.GC579@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com>
	 <1197116185.31440.1.camel@twins>
	 <1197132792.1568.162.camel@jnielson-xp.ddns.mvista.com>
	 <1197133910.6353.33.camel@lappy>
	 <1197133577.1568.166.camel@jnielson-xp.ddns.mvista.com>
	 <1197135413.6353.36.camel@lappy>
	 <3efb10970712081152o2d4abcfbo634a8d2445c09699@mail.gmail.com>
	 <20071208200801.GC579@elte.hu>
X-Google-Sender-Auth: 51f2b0d740a43ac3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

> no, you are wrong. If you want to do complex locking, you can still do
> it: take a look at the dev->sem conversion patches from Peter which
> correctly do this. Lockdep has all the facilities for that.
> (you just dont know about them)

Ok.

> the general policy message here is: do not implement complex locking. It
> hurts. It's hard to maintain. It's easy to mess up and leads to bugs.

Agree

> Lockdep just makes that plain obvious.
> Your mail and your frustration shows this general concept in happy

Please, do not see it as frustration, because it isn't...
I just want to understand it better.

> action: judging from your comments you have little clue about dev->sem
> locking and its implications and you'd happily go along and pollute the
> kernel with complex and hard to maintain nested locking constructs.

Now, you assume that i would _like_ complex locking. This is not true.

I just want to understand what was so wrong with dev->sem, I even read
in the discussions before about dev->sem, that it still was on the old
semaphore interface to get around lockdep issues, and _that_ is wrong.
That is bug-hiding from either the code or the tool. I just wanted to
understand if this was a lockdep bug, or a real code bug.

> Lockdep prevents you from doing it mindlessly, it _forces_ you to first
> understand the data structures, their locking and their relationship
> with each other. Then you can implement complexity, if you still want
> it.
>
> That, Sir, is a Good Thing (tm).

Completely agree.


Remy

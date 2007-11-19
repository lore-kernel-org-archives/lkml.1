Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbXKSMz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbXKSMz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbXKSMzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:55:49 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:2016 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbXKSMzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:55:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=bz16hYqPj65AgfOTvHFu757ZITPGht9tmJfYaLSYptJrD/KZ4P2NujZjeerigegPmB8Q5YC3HXDBWrKVYhAAEQkYT7x4CBRJEBxwwGCoRF6m6gUn8SBtx2raQ0L4QG5bicI0MxAEE5i3eQ3MVQ79cJVNjSON4RaMu0Uty21rBUc=
Message-ID: <3efb10970711190455n5e635823t40a320c4b444fa57@mail.gmail.com>
Date: Mon, 19 Nov 2007 13:55:45 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Daniel Walker" <dwalker@mvista.com>
In-Reply-To: <3efb10970711170736u469bbbc5p8c227ca2a12657dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
	 <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com>
	 <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
	 <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
	 <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
	 <Pine.LNX.4.58.0711170840130.4453@gandalf.stny.rr.com>
	 <3efb10970711170736u469bbbc5p8c227ca2a12657dd@mail.gmail.com>
X-Google-Sender-Auth: cf95c578b69697a5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steven,

> > OK, I wont be able to work on this this weekend, but I'll try to get to it
> > on Monday.  A better example to show the bug you are looking for is simply
> > create a mutex and create a thread that grabs that mutex and goes to
> > sleep. Have your driver read grab that mutex with
> > mutex_lock_interruptible. And if the signal code is broken with this, then
> > you definitely got a point that the inerruptible code is broken.

I removed the 'struct semaphore' completely from my driver, using real
mutexes now instead, replace the signalling semaphores by 'struct
completion' mechanisms and got rid of the possible race I saw with the
completions in a different way, and now the problem is completely
gone!

Posix Signals work properly now (no OOPS anymore), so the problem was
likely related to the way I used the 'struct semaphore' types, which
is thus different compared to the non-RT kernel and therefor quite
confusing.

So, thank you (and Daniel) for pointing me into the right direction.

Now lets get rid of the 'struct semaphore' completely in the kernel :-))


Kind Regards,

Remy Bohmer

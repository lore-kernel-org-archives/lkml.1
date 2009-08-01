Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbZHAPxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbZHAPxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 11:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZHAPxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 11:53:42 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:41970 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZHAPxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 11:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EBuPUELHiaNF5EDO66J0z3WKFSE4O1vqjdJ+3KMiI9zsL5Wd1EXmDIBEV7GuxmdjIS
         +ENLU+p0Ugn0/gzkMrtyczB5Wffr5fWB+ONlpkP3IyeqpwCer1Gcp2kUZeonzxlcwAgn
         8HhsDG4usnSXYKvuKxzL5jTa5apDrjsTXaQBQ=
Date: Sat, 1 Aug 2009 17:53:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [ANNOUNCE] Reiserfs/kill-bkl tree v2
Message-ID: <20090801155335.GA4836@nowhere>
References: <20090731174642.GA6539@nowhere> <20090801081141.GA18036@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090801081141.GA18036@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 01, 2009 at 10:11:41AM +0200, Andi Kleen wrote:
> On Fri, Jul 31, 2009 at 07:46:43PM +0200, Frederic Weisbecker wrote:
> > IV) Testing and review
> 
> You seem to have done a lot of benchmarks, but did you also do stress testing?
> 
> While a performance issue wouldn't be good, corrupting someone's file system
> would be really bad.



Heh, your are fairly right.
I've been focusing so much on performances regressions, that I forgot
this step.

Well, actually no I haven't forgot about it, but...
The problem is that the only SMP box I have is my personal laptop.
It has been sufficient to perform the dbench tests I've posted, but I could
do more (and more finegrained) tests with a separate box.

Then, indeed I could launch some stress tests in my laptop, but stress
tests should be run in another way than throughput tests, ideally
stress tests should run this tree for long hours (no, ideally: all the time),
whereas throughput tests can make it with punctual tests (though still,
it would be nicer to do more and more finegrained).

I have UP test boxes however, I will do long hours stress tests on it
next week but I fear that UP, even with CONFIG_PREEMPT can't open
enough racy windows to unearth the real wicked bugs that are waiting.

That said, and as you can guess while reading between the aboves lines,
one of my secret hopes while posting this announce was to get people
to test it, why not with stress tests, using better hardware
ressources than I have :-)


> e.g. running all the file system stress tests from LTP would be a good 
> idea, ideally multiple at a time on a multi processor system on a ram
> disk or perhaps AIM9.


Yeah good idea. But again, I fear my laptop hasn't enough memory
to support big enough ramdisks mount points to host selftests.

Anyway, I'll launch stress tests on one of my UP boxes next week,
and also some in my laptop.

Thanks!


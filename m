Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZBINem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZBINem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbZBINee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:34:34 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:56868 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbZBINed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:34:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p0fv6KssChsUtpHZv3H61JYRm8MgMN0fUXDh+oZ5VKn+XOCi15CLCNUHTpgq77e+Di
         3hWABYEfUrNWNAaEpuqPa64r/2wLpMWpqOoyyHhnKpmErSzjbRrlOm8MlYv+Y/nuecDr
         0a5Lj5KOI8oRovuIURuZoMN0cfq/Hd3eHjLyY=
Date: Mon, 9 Feb 2009 14:34:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fastboot: keep at least one thread per cpu during boot
Message-ID: <20090209133428.GA4705@nowhere>
References: <20090209034826.GA4768@nowhere> <20090208212748.4b7569b5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090208212748.4b7569b5@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 09:27:48PM -0800, Arjan van de Ven wrote:
> On Mon, 9 Feb 2009 04:48:27 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Async threads are created and destroyed depending on the number of
> > jobs in queue. It means that several async threads can be created for
> > a specific batch of work, then the threads will die after the
> > completion of this batch, but they could be needed just after this
> > completion for another batch of work. During the boot, such
> > repetitive thread creations can be wasteful, that's why this patch
> > proposes to keep at least one thread per cpu (if they already have
> > been created once). Such a threshold of threads kept alive will
> > prevent from a part of the thread creation overhead. This threshold
> > will be dropped one the system_state switches from SYSTEM_BOOTING to
> > SYSTEM_RUNNING.
> 
> I'm not very fond of this to be honest;
> at least during boot there's enough activity, and the time is so short
> (that's the point of the parallel stuff!) that this will not kick in to
> make a difference; specifically, every boot I've seen the number of
> threads is highest near the end, and also the total kernel boot time is
> below 1.5 seconds or so, not long enough for the threads to die.


My boot takes more time (about 5 seconds before modules loading).

 
> Creating a thread is *CHEAP*. Really really cheap. You can do 100
> thousands/second on even a modest CPU. If you have a high frequency of
> events, you don't want this, sure, and that is why there is a one
> second delay to give opportunity for reuse... but really....


Ok. And that's a problem with my patch. I did not have a suitable
testcase to produce a relevant benchmark: the aync insertions were to close
in time to capture something interesting.
If I saw the result of a testcase, I would have seen probably no different :-)

I guess you're right, this would have added new code to maintain for only micro optimizations...


> 
> Now, if async function calls get used more, I can see the point of
> always keeping one thread alive, just for both performance and VM low
> memory issues; but that's not what your patch is doing.


Ok.
Perhaps the testcase would be suitable under embedeed systems.
I will perhaps test one day :-)

Thanks!

> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org


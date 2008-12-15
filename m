Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbYLOSCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbYLOSCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 13:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYLOSCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 13:02:39 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:31373 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbYLOSCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 13:02:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=h/39UXWqO9jn+CRiRVadwHEu/pCSRf7wwfdld6WvEE6YLJszsRP+QrgNpiQjiuCIxn
         Bvb8hTmyvX3VVoMlLXt08WpkSYVW+ZbWQ9mrgMsjJPWmYStLc79HqKMUbg8vGaA6iT0z
         gLWYo6cfq8TLfroapInBTww9u+7Up8cRyemIE=
Message-ID: <661de9470812151002h15e523b0s85bf1537d6e7f5fe@mail.gmail.com>
Date: Mon, 15 Dec 2008 23:32:36 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: svaidy@linux.vnet.ibm.com, "Peter Zijlstra" <peterz@infradead.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Suresh B Siddha" <suresh.b.siddha@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Dipankar Sarma" <dipankar@in.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, "Gautham R Shenoy" <ego@in.ibm.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "David Collier-Brown" <davecb@sun.com>,
       "Tim Connors" <tconnors@astro.swin.edu.au>,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       "Gregory Haskins" <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH v5 4/7] sched: bias task wakeups to preferred semi-idle packages
In-Reply-To: <20081215122529.GR5457@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211173831.2020.57550.stgit@drishya.in.ibm.com>
	 <20081211174304.2020.14746.stgit@drishya.in.ibm.com>
	 <20081215070139.GE18403@balbir.in.ibm.com>
	 <1229329521.14605.17.camel@twins> <1229329984.14605.18.camel@twins>
	 <20081215084642.GJ18403@balbir.in.ibm.com>
	 <20081215122529.GR5457@dirshya.in.ibm.com>
X-Google-Sender-Auth: 496e1ed2e45c4358
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > > Sure its racy, but so what?
>> > >
>> > > The worst I can see it that we exclude a dying task from this logic,
>> > > which isn't a problem at all, since its dying anyway.
>> >
>> > At which point I seriously doubt it'd still be on the rq anyway.
>> >
>>
>> I forgot to mention that, the check should be (p->mm && !(p->flags & PF_KTHREAD))
>
> I can check for PF_KTHREAD for now.  However, I should reduce the
> number of checks since this may slow down wake_idle for sched_mc=2.
>
> We can tolerate p->mm check on a dying process as Peter has suggested,
> hence we don't need to protect it.  We are not going to access any
> contents of the mm struct.
>
> If PF_KTHREAD is only being used by AIO, then I feel we can drop the
> check since the threads will not have affinity and they can be moved
> to other cpus anyway.
>
> The main reason for skipping kthread is that they may be using per-cpu
> variables and sleep/preempted.  I did not want the wake_idle() logic
> to move them around forcefully.  This is not the general case and this
> situation should not happen.
>
> Second reason is to optimise on the affinity check since most of the
> kthreads have affinity and cannot be moved.
>
> This condition check needs optimisation after getting the framework
> functionally correct and useful.


Vaidy, you (or your mailer) seem to have dropped me off of the to/cc
list while replying and this seems to be the case for all replies.

Balbir

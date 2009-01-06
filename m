Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZAFEfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZAFEfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 23:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZAFEfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 23:35:31 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:19844 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbZAFEfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 23:35:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=bdXFi/70i+w/Jecr5mI0P0wtVw6qLO9mQCe28xcIU5wOlJICXLt+OPKn9E3wvzdQ8W
         fWbvDXPYKGt7Hgu0Ii37NISyOambtQ9gTrCM1ZWLa35DnPslTtX9HeNEzIzRDvbHP6Do
         /3vc1OL7qnP+axY8CN8AF3KkrQLNk30ZDF8QA=
Message-ID: <3ae3aa420901052035k1ec6a8cn9e8adab266954861@mail.gmail.com>
Date: Mon, 5 Jan 2009 22:35:29 -0600
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "john stultz-lkml" <johnstul.lkml@gmail.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: "Chris Adams" <cmadams@hiwaay.net>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <1f1b08da0901051821q31a5c98akc5165aac36c6201e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <20090103002114.GA1538533@hiwaay.net>
	 <1f1b08da0901051821q31a5c98akc5165aac36c6201e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/5 john stultz-lkml <johnstul.lkml@gmail.com>:
> On Fri, Jan 2, 2009 at 4:21 PM, Chris Adams <cmadams@hiwaay.net> wrote:
>> Basically (to my untrained eye), the leap second code is called from the
>> timer interrupt handler, which holds xtime_lock.  The leap second code
>> does a printk to notify about the leap second.  The printk code tries to
>> wake up klogd (I assume to prioritize kernel messages), and (under some
>> conditions), the scheduler attempts to get the current time, which tries
>> to get xtime_lock => deadlock.
>
> This analysis looks correct to me.
>
> Grrrr. This has bit us a few times since the "no printk while holding
> the xtime lock" restriction was added.
>
> Thomas: Do you think this warrents adding a check to the printk path
> to make sure the xtime lock isn't held?

No.

> This way we can at least get a
> warning when someone accidentally adds a printk or calls a function
> that does while holding the xtime_lock.

This seems like a basic mistake, that should be avoidable
with code review.  I'm sort-of surprised to even see it; anyone
even vaguely familiar with that code would spot it quickly.
Heh. Take that with a grain of salt -- not like I never make
mistakes ;-/

I mean, how many more times can the mistake be made?
I'm arguing its gonna be zero.

--linas

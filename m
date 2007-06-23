Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbXFWRDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbXFWRDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 13:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbXFWRC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 13:02:57 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:60261 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbXFWRC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 13:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SKjQ2bSO5CCaw8AcMyOZi6/xqHQ1K/qwvCQNsptpAWXpiX2gAUSs6+hPo7MdB+YaA821ZdaKfSPcR02qTleyaCMGw3wjrxPx8mce7eMFxigdoJk+0qiLU15qJj3/3VobdBn4/2Rv07Fu5h4RrM9paf3n938wAft0I4GbmbVRpHc=
Message-ID: <a781481a0706231002jf4467ebja6c28e3e242ceb76@mail.gmail.com>
Date: Sat, 23 Jun 2007 22:32:55 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: "upping" a semaphore from interrupt context?
Cc: "Arnd Bergmann" <arnd@arndb.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       "Florin Iucha" <florin@iucha.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200706231752.08494.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622173839.GB8398@iucha.net>
	 <200706231402.03617.arnd@arndb.de>
	 <a781481a0706230842l141cf400tb2f5645b6b6537fe@mail.gmail.com>
	 <200706231752.08494.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/23/07, Oliver Neukum <oliver@neukum.org> wrote:
> Am Samstag, 23. Juni 2007 schrieb Satyam Sharma:
> > * 3. set up a timer and schedule another function to service the
> > * interrupt / do what needs to be done then, hopefully the mutex
> > * would be uncontended then => *gargh*
>
> You could use schedule_work(). However then why not use it always.
> This would make sense if what you want to do is outright trivial.

If you use schedule_work() to pass off work from interrupt context
to process context, then you wouldn't be calling down_trylock()
from interrupt context in the first place (which is what is being
discussed here). You would simply pass off the entire code that
uses the shared data (and wraps a *proper* down() or mutex_lock()
around it, not the _trylock() variant) to the workqueue.

Also, that is precisely my point too. What I'm saying is that it is
generally poor design to be wanting to use the _trylock() variant
of semaphore / mutex in interrupt context. Workqueues _are_ the
preferred mechanism to use for (most) such cases where you need
to do something that may require you to sleep.

Satyam

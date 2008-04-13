Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbYDMOzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbYDMOzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 10:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYDMOz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 10:55:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:50449 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbYDMOz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 10:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gJwhfJR6iJOxCzx+bnRSl1T52hEUgWMzk0Syclq7BvrFGgV4DmeSElDu3rmtUOK/9Ktk6hzXYJ9aA6F6jvHORTY5TXFz6tlZeMNJfgVtdz9rzh2Y20aHAWQ3qg/64YIB2QcqMV/pXBQQjDnxU/GOj5SXyYetf2v61HPzeRscCk8=
Message-ID: <e2e108260804130755r3c2cac0fnaa0c570707f2b53b@mail.gmail.com>
Date: Sun, 13 Apr 2008 16:55:25 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] Replace completions with semaphores
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Roland Dreier" <rdreier@cisco.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Ingo Oeser" <ioe-lkml@rameria.de>,
       "Daniel Walker" <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@osdl.org>
In-Reply-To: <20080413070833.GC19773@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080411210022.GJ11962@parisc-linux.org>
	 <1208003081.7427.7.camel@twins>
	 <20080412172606.GL11962@parisc-linux.org> <adaskxqrgsl.fsf@cisco.com>
	 <20080412204748.GN11962@parisc-linux.org>
	 <20080413070833.GC19773@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 9:08 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  but semaphores will be _removed_, _completely_. Rewriting them in
>  generic C code is just the first step towards that - it consolidates all
>  the myriads of semaphore implementations that Linux has spread out.
>
>  your proposed change to change completions to semaphores is totally
>  backwards and prolongs an API we want to get rid of. Did you miss this
>  aspect of the mutex rewrite, of the semaphore-to-mutex,
>  semaphore-to-completions and semaphore-to-rwsem conversions?

I know the semaphore-to-mutex rewrites were essential a.o. to make
further merging of the real-time tree into the mainstream Linux kernel
possible. But the semaphore concept is more powerful than the mutex
concept: semaphores can be used to let one thread wait for a state
change reported by another thread. Should all state-change-waiting be
implemented via wait_event*() functions ?

One of the strengths of the Linux kernel is that the barrier for new
developers is low: in theory anyone familiar with the C programming
language can start writing kernel drivers. Most people still learn
kernel development via the third edition of the "Linux Device Drivers"
book, and with some luck or some help, they come across an overview of
the 2.6 kernel API changes (http://lwn.net/Articles/2.6-kernel-api/).
The LWN book is getting outdated after all the 2.6 kernel API changes,
and the page with 2.6 kernel API changes was last updated six months
ago. Where can a kernel developer find up to date information about
kernel programming ?

Bart.

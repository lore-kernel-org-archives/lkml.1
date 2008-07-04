Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbYGDCz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbYGDCz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 22:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYGDCzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 22:55:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:49470 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbYGDCzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 22:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BithMtR1zQF6th/kvyAwt/ORnRF8/uRkcIaML6oVkjvfHSU3MIxqmOpCxrMuX4MlMe
         5DyQaxejd9KrVhAYBSOElJ3fLTDHl5k+UWGcHy/pH2v4ekPUkCR2Csb7OPdAwLoqoGgn
         iIthR1AII/P8wpvfut1zWZbJtkIp4JnWSSiq8=
Message-ID: <aec7e5c30807031955v7f304b03jcf7298dfcf90cfa6@mail.gmail.com>
Date: Fri, 4 Jul 2008 11:55:08 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] uio: User IRQ Mode
Cc: "Paul Mundt" <lethal@linux-sh.org>,
       "Uwe Kleine-K??nig" <Uwe.Kleine-Koenig@digi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <20080703195538.GC3197@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se>
	 <20080702125400.GC3199@local> <20080703071019.GC12214@digi.com>
	 <20080703124505.GB3197@local> <20080703132316.GA1040@linux-sh.org>
	 <20080703195538.GC3197@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2008 at 4:55 AM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Thu, Jul 03, 2008 at 10:23:16PM +0900, Paul Mundt wrote:
>> On Thu, Jul 03, 2008 at 02:45:05PM +0200, Hans J. Koch wrote:
>> > On Thu, Jul 03, 2008 at 09:10:19AM +0200, Uwe Kleine-K??nig wrote:
>> > >     Moreover this might prevent some bugs.  (And obviously this
>> > >     function has the potential to have a buggy implementation as
>> > >     the comment by Alan Cox shows.)
>> >
>> > For me, this shows two things:
>> >
>> > - I never ever had to use disable_irq_nosync() in any UIO driver yet,
>> >   otherwise I would have noticed.
>> >
>> > - Magnus turned in a patch that he never tested.
>> >
>> Note that the deadlock in question is in relation to SMP, it's true that
>> the patch was never tested in an SMP environment and only on UP, but it
>> certainly was tested.
>
> Ok, so I take back that accusation ;-)

That's good, thank you. In the future it would be even better if you
didn't accuse to begin with, since that will only heat up the
discussion.

> Nonetheless, the patch changes a UIO core file, and everything in there
> should work in all situations on all architectures unless there is a
> _very_ good reason to do something different. This not only applies to
> SMP issues but also to the limitation to non-shared interrupts.

I will resolve the SMP issue and repost, no problem.

>> The vast majority of driver writers don't have a
>> need to use disable_irq_nosync(), so whether you've had to use it or not
>> is largely irrelevant to the conversation at hand ;-)
>
> Sure ;-) I merely wanted to point out that this is an unusual way to
> handle an interrupt.

Grep shows that there is nothing unusual about it.

damm@rx1 ~/git/linux-2.6 $ find drivers/ | xargs grep -m 1 -e
[[:blank:]]disable_irq\( -e [[:blank:]]disable_irq_nosync\( | wc -l
105

/ magnus

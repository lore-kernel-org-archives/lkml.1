Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZFXWOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZFXWOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZFXWOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:14:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:12262 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZFXWOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:14:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=CG/AhU4Dxjh6wfWQo0xvTpx748BWaQ2oY8nbr+iGf+XzPS87nFqpcTOkW22S45t0R
	qmANrU/L+1X2C1i5o7s7g==
MIME-Version: 1.0
In-Reply-To: <1245849223.32124.112.camel@desktop>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop>
	 <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	 <1245849223.32124.112.camel@desktop>
Date: Wed, 24 Jun 2009 15:14:36 -0700
Message-ID: <a55d774e0906241514w761f86fva294784583cdd8a4@mail.gmail.com>
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny && usage
From: Brian Swetland <swetland@google.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/24 Daniel Walker <dwalker@fifo99.com>:
> On Fri, 2009-06-19 at 17:13 -0700, Arve Hjønnevåg wrote:
>>
>> These are mostly questions for the framework team. The binder driver
>> is there to support our user space code. At some point we used the
>> driver from www.open-binder.org, but we ran into, and fixed, a lot of
>> bugs (especially when processes died), so we determined it would be
>> faster to rewrite the driver from scratch.
>
> Is there someone in your framework team that would be willing to respond
> to these questions ? (I know you added hackbod to the CC, but they
> aren't responding..)

I guess it depends on the questions -- for good or ill, it's what is
in use and replacing it with a different mechanism would be a pretty
huge effort that there's unlikely to be time for in the near future.
Quite a bit of the userspace framework depends on the binder handling
the remote reference counting, object lifespan, etc, stuff and it's
subtle and hairy to debug.  Moving to a different transport is
possible (it's just software, as they say), but there's a lot of code
that depends on the behavior that exists today.

If the binder is absolutely unacceptable as something to be included
in the linux kernel (that's a message that I seem to be getting here),
I think the best thing for us to do is maintain it in our tree for now
and focus on stuff that is far less controversial.

For example the msm7k SoC code may need some various cleanup, but I
think at the end of the day adding support for a new ARM based SoC and
peripherals is not going to be that contentious.  The
wakelock/suspendblock stuff is a bit further out there, but there
seemed to be some good progress on getting it reviewed and revised on
the linux-pm list, last I saw.

Brian

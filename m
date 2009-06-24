Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZFXWtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZFXWtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbZFXWth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:49:37 -0400
Received: from fifo99.com ([67.223.236.141]:54936 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391AbZFXWtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:49:36 -0400
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
	usage
From: Daniel Walker <dwalker@fifo99.com>
To: Brian Swetland <swetland@google.com>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com
In-Reply-To: <a55d774e0906241514w761f86fva294784583cdd8a4@mail.gmail.com>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop>
	 <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	 <1245849223.32124.112.camel@desktop>
	 <a55d774e0906241514w761f86fva294784583cdd8a4@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 15:49:38 -0700
Message-Id: <1245883778.32124.214.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 15:14 -0700, Brian Swetland wrote:
> 
> I guess it depends on the questions -- for good or ill, it's what is
> in use and replacing it with a different mechanism would be a pretty
> huge effort that there's unlikely to be time for in the near future.
> Quite a bit of the userspace framework depends on the binder handling
> the remote reference counting, object lifespan, etc, stuff and it's
> subtle and hairy to debug.  Moving to a different transport is
> possible (it's just software, as they say), but there's a lot of code
> that depends on the behavior that exists today.

I'm really interested in how binder was picked. It seems like a dead
technology (hasn't been touched in 3 years according to open-binder.org)

I think the best option is to write a layer over D-Bus that implements
the binder API. I don't think that would be too difficult since D-Bus
does IPC, binder does IPC, and the differences should be worked out with
a layer between the two. D-Bus seems like the best solution since it has
the best community backing..

> If the binder is absolutely unacceptable as something to be included
> in the linux kernel (that's a message that I seem to be getting here),
> I think the best thing for us to do is maintain it in our tree for now
> and focus on stuff that is far less controversial.

Yes... I'm refraining from doing more cleanups because it seems like a
lost cause. 

> For example the msm7k SoC code may need some various cleanup, but I
> think at the end of the day adding support for a new ARM based SoC and
> peripherals is not going to be that contentious.  The
> wakelock/suspendblock stuff is a bit further out there, but there
> seemed to be some good progress on getting it reviewed and revised on
> the linux-pm list, last I saw.

Do you have a msm branch someplace that is strictly msm support with
absolutely no generic changes mixed in?

The only thing in staging that is less controversial from my perspective
is ram_console.c that could actually be cleaned up and possibly merged.

Daniel


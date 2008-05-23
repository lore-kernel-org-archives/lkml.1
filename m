Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbYEWFgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbYEWFgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYEWFg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:36:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:46637 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbYEWFg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:36:29 -0400
Subject: Re: [PATCH 3/3] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a36005b50805222224g79477cb2md5298bbf4e35bcfb@mail.gmail.com>
References: <20080523042923.594531457@mvista.com>
	 <20080523042923.916202203@mvista.com>
	 <a36005b50805222202v6ea7b50p988eab5524935e1a@mail.gmail.com>
	 <1211519720.18130.98.camel@localhost.localdomain>
	 <a36005b50805222224g79477cb2md5298bbf4e35bcfb@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 22:36:27 -0700
Message-Id: <1211520987.18130.110.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-22 at 22:24 -0700, Ulrich Drepper wrote:
> On Thu, May 22, 2008 at 10:15 PM, Daniel Walker <dwalker@mvista.com> wrote:
> > That's the problem we aren't just covering 99.99% we're trying to cover
> > 100% of cases.. If we don't do it in that one case we may as well not do
> > it at all.
> 
> I have no problem with removing the other ordering.  It was added
> because it limited overhead.  It is completely wrong to have everybody
> pay for the needs for a very small minority.

I think that ordering is something companies have been wanting for a
long time.. I had a lot of people asking about it, I was glad when it
was added.. However, it all falls down in the one case which we don't
handle. 

I don't think the overhead for this is all that bad.. Consider that the
worst performance case is the contended case, and this patch adds a very
small amount of code. The vast majority of cases are un-contended , and
it's already know to be slow in the cases which are contended.

Daniel


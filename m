Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbXE3XcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbXE3XcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbXE3XcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:32:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbXE3XcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:32:05 -0400
Date: Wed, 30 May 2007 16:32:36 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>, axboe@kernel.dk,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] drivers/block/ub.c: use list_for_each_entry()
Message-Id: <20070530163236.8bd5640c.zaitcev@redhat.com>
In-Reply-To: <adasl9dq4zq.fsf@cisco.com>
References: <20070530084752.GE14284@traven>
	<20070530123840.e54d73c2.zaitcev@redhat.com>
	<a781481a0705301414t4a0c1b2epe5e14b62ec8dc872@mail.gmail.com>
	<20070530160850.0c536d55.zaitcev@redhat.com>
	<adasl9dq4zq.fsf@cisco.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 16:14:01 -0700, Roland Dreier <rdreier@cisco.com> wrote:

>  > The negative is the sheer number of helper functions in list.h. Personally,
>  > I find it difficult to retain a working knowledge of them. Iterators are
>  > particularly nasty that way. I'm thinking about dropping all of these
>  > list_for_each_with_murky_argument_requirements_and_odd_side_effects()
>  > and use plain for(;;), as a courtesy to someone who has to read the
>  > code years down the road.
> 
> I think I disagree with this reasoning.  If I'm reading your code and
> I see, say, list_for_each_entry_safe(), I can be pretty confident that
> your loop works correctly.  If you write your own for loop, then I
> have to check that you actually got the linked list walking right.

You have to check that I used list_for_each_entry_safe correctly too,
which is harder. Are you aware that we had (and probably still have)
dozens of cases where the use of list_for_each_entry_safe was buggy?
Most of them involved IHV programmers being lured into false sense
of security by the _safe suffix and getting their locking wrong.

You could not find a better way to blow up your own argument
than to mention list_for_each_entry_safe(), which is anything but.
Matthias' use of list_for_each_entry() actually IS safe, which is
why I am not NAKing it. Andrew has accepted it already. I just
think we aren't winning squat here.

-- Pete

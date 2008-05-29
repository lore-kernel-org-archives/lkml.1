Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYE2DZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYE2DZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYE2DZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:25:30 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42834 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304AbYE2DZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:25:29 -0400
Subject: Re: [PATCH][-mm] reclassify sg_sysfs_class for lockdep
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, matthew@wil.cx,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <a8e1da0805281745g31c8217fk860dfe17cc674be5@mail.gmail.com>
References: <20080527101009.GA3015@darkstar.te-china.tietoenator.com>
	 <1211985600.3445.14.camel@localhost.localdomain>
	 <a8e1da0805281745g31c8217fk860dfe17cc674be5@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 28 May 2008 22:25:22 -0500
Message-Id: <1212031522.3445.138.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 08:45 +0800, Dave Young wrote:
> > This isn't really a generic solution, is it?  It only works because we
> > currently only have two users of the interface functions, so if we
> > reclassify one they look separate to lockdep.  It will fall over again
> > if we ever get another one.
> >
> > Surely the correct fix is to initialise lockdep for the mutex the same
> > way we did for the semaphore in class_register() (which does exactly the
> > same locking without triggering lockdep)?  That way we'll also fix the
> > problem for other conversions of semaphore->mutex.
> 
> Matthew & greg did the work already.

Yes, that was nice of them ...

> >From my original idea I don't want to do this for all classes, and I
> would think it as a rare case.

Hardly ... the fact that it showed up in two different cases indicated
the problem to be more generic.

The root cause of the problem was that mutexes are part of the lockdep
infrastructure whereas semaphores aren't and the dynamic initialisation
of mutexes becomes a lockdep problem unless they're keyed and
initiallised correctly. If you want to do more semaphore->mutex
conversions, it would really be useful for you to understand what was
done and why it was necessary ... because it's going to become necessary
again in others of them.

James



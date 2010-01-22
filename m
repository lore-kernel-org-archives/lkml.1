Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727Ab0AVM3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab0AVM3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 07:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144Ab0AVM3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 07:29:50 -0500
Received: from smtp.nokia.com ([192.100.122.230]:19231 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0AVM3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 07:29:49 -0500
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Don Mullis <don.mullis@gmail.com>, linux-kernel@vger.kernel.org,
       airlied@redhat.com, david@fromorbit.com
In-Reply-To: <87k4vah12u.fsf@basil.nowhere.org>
References: <87fx609i29.fsf@gmail.com>
	 <20100121175914.GA8910@basil.fritz.box> <87vdeu96bo.fsf@gmail.com>
	 <87k4vah12u.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 14:29:08 +0200
Message-Id: <1264163348.3032.240.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Jan 2010 12:29:13.0057 (UTC) FILETIME=[8136E510:01CA9B5E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 11:43 +0100, Andi Kleen wrote:
> Don Mullis <don.mullis@gmail.com> writes:
> >
> > Being just a dumb library routine, list_sort() has no idea what context
> > it's been called in, how long a list a particular client could pass in,
> > nor how expensive the client's cmp() callback might be.
> >
> > The cmp() callback already passes back a client-private pointer.
> > Hanging off of this could be a count of calls, or timing information,
> > maintained by the client.  Whenever some threshold is reached, the
> > client's cmp() could do whatever good CPU-sharing citizenship required.
> 
> need_resched() does all the timing/thresholding (it checks the 
> reschedule flag set by the timer interrupt). You just have to call it.
> But preferable not in the inner loop, but in a outer one. It's
> not hyper-expensive, but it's not free either.
> 
> The drawback is that if it's called the context always has to
> allow sleeping, so it might need to be optional.
> 
> Anyways a better fix might be simply to ensure in the caller
> that lists never get as long that they become a scheduling
> hazard. But you indicated that ubifs would pass very long lists?
> Perhaps ubifs (and other calls who might have that problem) simply
> needs to be fixed.

No, they are not very long. A hundred or so I guess, rarely. But we need
to check what is really the worst case, but it should not be too many.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


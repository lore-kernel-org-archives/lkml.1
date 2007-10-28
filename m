Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbXJ1Sd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbXJ1Sd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXJ1SdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:33:19 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48538 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbXJ1SdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:33:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Adrian Bunk <bunk@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Kir Kolyshkin <kir@swsoft.com>,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       kir@openvz.org
Subject: Re: [Devel] [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take 2)
References: <CBC546DD07068244AEC110EFEDA58B7235893F@excite.int.sw-soft.com>
	<m1ve8ty1tq.fsf@ebiederm.dsl.xmission.com>
	<20071027002448.GH30533@stusta.de>
	<m18x5puyw7.fsf@ebiederm.dsl.xmission.com> <4724B4F2.7070500@goop.org>
	<20071028170008.GD7227@stusta.de>
Date: Sun, 28 Oct 2007 12:31:30 -0600
In-Reply-To: <20071028170008.GD7227@stusta.de> (Adrian Bunk's message of "Sun,
	28 Oct 2007 18:00:08 +0100")
Message-ID: <m13avvqef1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> On Sun, Oct 28, 2007 at 09:12:34AM -0700, Jeremy Fitzhardinge wrote:
>> Eric W. Biederman wrote:
>> > Roughly that sounds like CONFIG_EXPERIMENTAL to me.  But I would
>> > be happy to hear if someone has a better idea.
>> 
>> Rather than overload an existing config option, why not add one with the
>> specific semantics you want: CONFIG_UNSTABLE_UABI.  The problem seems
>> like one which which may occur again, though one hopes not too often.  I
>> guess the risk is that people will leave their subsystems depending on
>> it permanently (sysfs?), so it ends up being set all the time and
>> becomes as useless as EXPERIMENTAL...
>
> Then let SYSFS depend on UNSTABLE_UABI for the next 10 years and we have 
> an excuse for breaking the ABI with each new kernel...
>
> Either the ABI is stable or it should not be exposed to users at all.

If we need a new config for it.  CONFIG_IMMATURE is the closest I
can think of.

Horrible ABI damage like reassigning magic numbers won't happen.
Argument passing won't change (unless it is simply impossible).
However there are little details which might change.  Things like
error codes or the behavior in unlikely circumstances.  Bugs are
expected to exist and so we bug compatibility isn't expect to be
maintained.

The bottom line is that when things are new they are immature and
very rarely do they come out of the gate perfect.  That is something
we need to recognize and deal with.  We need to communicate this
to our users (distros and other developers) and we need to work
quickly to get the kinks out so that the code really is mature.

I'm not looking for excuses to mess up or do the wrong thing.
I just know that as an engineer getting it perfect out of the
gate isn't going to happen.  So I'm doing what I can to ask
people to ease into using something new.

Eric

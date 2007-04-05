Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbXDEAt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbXDEAt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbXDEAt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:49:27 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:44960 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbXDEAt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:49:26 -0400
Date: Wed, 04 Apr 2007 20:49:19 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
In-reply-to: <1175723728.6274.2.camel@obelisk.thedillows.org>
To: linux-kernel@vger.kernel.org
Cc: Dave Dillow <dave@thedillows.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       ray-gmail@madrabbit.org, amanda-hackers@amanda.org,
       amanda-users@amanda.org
Message-id: <200704042049.19789.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704010100.19016.gene.heskett@verizon.net>
 <20070404132949.f6fbca9f.akpm@linux-foundation.org>
 <1175723728.6274.2.camel@obelisk.thedillows.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007, Dave Dillow wrote:
>On Wed, 2007-04-04 at 13:29 -0700, Andrew Morton wrote:
>> On Wed, 04 Apr 2007 14:17:13 -0400
>>
>> Dave Dillow <dave@thedillows.org> wrote:
>> > The thing is, it's been broken for a long time -- this change just
>> > highlighted it. This isn't the first time that device-mapper has
>> > moved -- the introduction of mdp (before git, so haven't tracked
>> > down timeframe) also moved it around. The dynamic major is not
>> > stable, so should we be concerned if it moves for 2.6.21?
>> >
>> > I don't like the effect it has on the backups, but I don't think we
>> > should hand out LOCAL/EXP majors to dynamic devices, either. There
>> > is a module option to make the device-mapper and mdp majors stable,
>> > so perhaps a compromise is possible? Revert for 2.6.21, and schedule
>> > the patch for later addition, which gives distros time to use the DM
>> > major option?
>>
>> hm, good points.
>>
>> Overall, the patch helps kernel developers and hurts the userbase.  I
>> tend to prefer to hurt kernel developers than our users ;)
>>
>> I don't think the protect-lanana-numbers thing is very important,
>> really. If some kernel developer or someone who is maintaining an
>> unofficial out-of-tree driver hits the problem, they are presumably
>> able to handle it.  Preferably by switching to a dynamically-assigned
>> major.
>
>Works for me; I don't really have a dog in the fight.

I do, but now that I know that the problem is, and why the fix was done, 
I'm ambivalent as to how it should be fixed.  In this case the dog 
getting bit is tar (I have NDI if dump is also effected as I don't use 
it), and I would rather see tar made immune to the effects of a patch 
that was originally made to correct practice into a little closer to what 
the preacher said.

I see the facts as:
 1. the name of the directory didn't change,
 2. the inode contents aren't (ANAICT) modified in any way, and
 3. the file is still the file it was back in July of last year when I 
wrote it.

Perhaps someone can explain to me why tar thinks its all new just because 
the mapper was spanked and made to be a good puppy?

In my mind at least, its tar that has the egg on its face, and its tar 
that needs to be immunized.  Can someone tell me where am I wrong?

I'd really like to know why there is an apparent connection between this, 
and tars response, which is to think the whole disk is new and has to 
have a level 0 backup all over again.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
If God had a beard, he'd be a UNIX programmer.

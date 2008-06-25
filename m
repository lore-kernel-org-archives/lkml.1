Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYFYLY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYFYLY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYFYLYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:24:21 -0400
Received: from nebensachen.de ([195.34.83.29]:45075 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbYFYLYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:24:20 -0400
X-Hashcash: 1:20:080625:bzolnier@gmail.com::zdFc2NxN4JDyZopy:00000000000000000000000000000000000000000001ewo
X-Hashcash: 1:20:080625:alan@lxorguk.ukuu.org.uk::t2QylaqkGNRqVfPp:0000000000000000000000000000000000000IZM0
X-Hashcash: 1:20:080625:linux-ide@vger.kernel.org::NrhdwvOUsXLKKy/4:0000000000000000000000000000000000002eC6
X-Hashcash: 1:20:080625:linux-kernel@vger.kernel.org::dJ3eMXzkW7Vi9INJ:0000000000000000000000000000000000nxS
X-Hashcash: 1:20:080625:randy.dunlap@oracle.com::56LXc5iCBCnLVQR2:000000000000000000000000000000000000009fHz
From: Elias Oltmanns <eo@nebensachen.de>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
References: <87k5gmz596.fsf@denkblock.local>
	<200806240041.42796.bzolnier@gmail.com>
	<87skv3s3d9.fsf@denkblock.local>
	<200806241306.42054.bzolnier@gmail.com>
	<20080624133218.6bccab75@lxorguk.ukuu.org.uk>
	<58cb370e0806240621g61370f56j660e31790dad89c3@mail.gmail.com>
	<20080624143548.24dcf511@lxorguk.ukuu.org.uk>
	<58cb370e0806240719o4a70537p4a6fb64e9086e2d8@mail.gmail.com>
Date: Wed, 25 Jun 2008 13:23:53 +0200
Message-ID: <87k5gdn4fq.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com> wrote:
> On Tue, Jun 24, 2008 at 3:35 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>> > I don't see why you think it's "hard". We have timeout handlers for many
>
>>> > commands and those reset/abort just fine.
>>>
>>> They are different beasts from user-space initiated abort operation
>>
>> No they are not. They are the *same* thing in every respect.
>>
>> You have the drive in an unknown state, you want it back. If your drive
>> lost a command due to noise or a firmware flaw you have no idea about the
>> state it is actually in (supposed to be is irrelevant)
>
> I generally agree with you w.r.t. to drive side of the operations but
> the drive is only part of the equation (the host and the request states
> are the others) so 'supposed to be is' is quite relevant.
>
> Also abort request can happen i.e. while the command is being prepared
> & issued (it is done without ide_lock being taken and the timeout is not
> even armed yet) so there are additional issues to take care of.

Yes there are. Still, I think it should be feasible which is why I
personally would prefer to drop the second patch in the series for the
time being. But then I can keep it around for reference locally and the
original infrastructure can be found in the history after all.

Even though the patch series currently doesn't fully restore the
intended functionality, I'd like to merge it now. Command aborting
didn't work reliably (if at all) before and now, at least, a simple
ioctl won't harm a healthy system anymore. Since I think that we can add
command aborting back later, I'd like to keep the HDIO_DRIVE_RESET ioctl
even if it should currently be superfluous given SG_IO.

So, here comes the second run of the patch series based on
next-20080624. All suggested changes have been incorporated except for
one additional check for ->rq_disk which I consider unnecessary (and you
haven't insisted on it). In particular, this means that in the second
patch the ->resetting member has been removed from the ide_hwgroup_t
structure for completeness' sake (even though I'm not all in favour of
applying that second patch just yet).

Regards,

Elias

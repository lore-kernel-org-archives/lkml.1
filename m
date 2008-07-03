Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbYGCMks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbYGCMks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYGCMkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:40:40 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:54267 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYGCMkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:40:40 -0400
Message-ID: <486CA7BD.10206@keyaccess.nl>
Date: Thu, 03 Jul 2008 12:19:41 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Brownell <david-b@pacbell.net>, Michael Buesch <mb@bu3sch.de>,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] gpiolib: Allow user-selection
References: <200807022346.53222.mb@bu3sch.de>	<20080702170431.56d4c929.akpm@linux-foundation.org>	<200807022200.49428.david-b@pacbell.net>	<20080702220842.44364045.akpm@linux-foundation.org>	<486C8F9C.7080507@keyaccess.nl> <20080703020106.fec84f0f.akpm@linux-foundation.org>
In-Reply-To: <20080703020106.fec84f0f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03-07-08 11:01, Andrew Morton wrote:

> On Thu, 03 Jul 2008 10:36:44 +0200 Rene Herman <rene.herman@keyaccess.nl> wrote:

>> Development needs to happen against something relatively stable 
>> really and the last release would generally seem to be the best
>> choice.
> 
> Well one can develop against mainline and port to linux-next and then
> do a quick test.  But it seems like pointless additional overhead to
> me.

Other than developer needing a relatively stable base to develop against 
and run so as to concentrate on the effects of own code certainly people 
that said developer wants to test that which is in development want such 
a base. Fewer testers can/will be testing a particular feature if to do 
so they need to first drag in megabytes upon megabytes of other changes 
as well.

Last iteration I looked at and tested PNP patches and was using .25 as 
base which went smoothly. Then at 26-rc1 I needed to start running that 
since patches were against that which delayed things for a long time 
while I needed to find time to deal with that many unrelated changes 
some of which rather violently broke stuff here (ISA DMA most profoundly).

So should I have caught the ISA DMA breakage before it hit -rc1? Given 
that I tend to care about sound/isa which is its main user, perhaps. But 
the point was that I was trying to test ISAPnP, yet another thing that 
sound/isa is a main user of...

Many users/testers simply do not want to be running bleedin' edge all of 
the time because they'd be spending way too much time fighting bugs in 
places that are of no particular interest to them and when features are 
developed against said edge, you'd have just limited your tester base 
further to those who either will, or have enough sophistication to take 
the change in isolation and backport it to their current kernel 
themselves. And do it again on the next iteration of the feature.

As recently as yesterday I stalled on testing an ALSA patch when I saw 
it fail against mainline and wished for some other model than always 
having to run the very latest.

Not to sound overly pompous (I hope) but not everyone can be responsible 
for all these integration pains. People in corner A tend to care about 
corner A and might consider corners B, C and D unwelcome distractions 
mostly. Linux then has people like you and Linus to stand in the middle 
and make all the corners get along again.

Yes, porting to and checking -next before submission makes perfect sense 
but developing against it -- please not...

Rene.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYFZXY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYFZXY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 19:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYFZXYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 19:24:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55232 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYFZXYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 19:24:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH 48/60] microblaze_v4: headers simple files - empty or redirect to asm-generic
Date: Fri, 27 Jun 2008 01:23:05 +0200
User-Agent: KMail/1.9.9
Cc: monstr@seznam.cz, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       Michal Simek <monstr@monstr.eu>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <200806261838.33787.arnd@arndb.de> <20080626180530.GA22827@cs181140183.pp.htv.fi>
In-Reply-To: <20080626180530.GA22827@cs181140183.pp.htv.fi>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806270123.06669.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+oXltUXzIcXtx09MpIgGaCgJDAeFrO6btDfvG
 AvDlBgOMFav2aVpPVwrGxBn9WOEfIgmdqnh/eKYk9qkVmQxjhR
 4ISw4zlg1bn+sca2YyaVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, Adrian Bunk wrote:
> Honestly, I do not completely like your approach of getting the 
> microblaze port submitter to create the asm-generic files - I would 
> personally prefer if the microblaze port would look exactly like all 
> other ports and the (reasonable) changes you have in mind were not
> being discussed and done as part of the submission of a new port.

But it works really well this way ;-). My point is that a new port
should look just like all the other ports should have looked as
well, not like they did. When it comes to the ABI, you
cannot make incompatible changes after it's merged, so IMHO all
ABI defining headers should go to asm-generic if possible.

Since there doesn't seem to be anyone investing work into moving the
files there (I started it before, but got bored before submitting
them all myself), the point of adding a new architecture is exactly
the right one for putting the file to asm-generic. For Michal, there
is no difference between putting the file into asm-generic or
asm-microblaze, other than that he has to change his existing
patch once, but in return he gets fewer files to maintain afterwards.

The fundamental principle here is: if you want your code to get in,
do it in a way that makes your own code cleaner by making it cleaner
for everyone else as well.
The result is that more people look at the code, and that Michal's
name gets more widely known, so the next time he needs something
from another developer, he's more likely to get heard because
you think of him as the person that did all the useful work on
the asm-generic files.

> After all, it won't matter whether we'll unify resp. remove
> 22 or 23 files.

That wasn't my idea. The logic was that if one more file exists
in asm-generic that can be removed from the architectures,
we get 22 more files to remove without anyone having to look
at the big picture. When microblaze is in, I can compile a list
with asm-generic files that can be used to replace the architecture
specific files, so the arch maintainers can decide on their own
whether to clean their own stuff up or not.

With namei.h, I may have gone too far to request moving it
to asm-generic as part of the microblaze merge, because it's
not an ABI header, but I think it's a step in the right direction
anyway, and I may put it there myself if I ever get to do
my "how to port Linux to a new architecture the right way" paper.

	Arnd <><

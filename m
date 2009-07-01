Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZGANRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZGANRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZGANRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:17:14 -0400
Received: from mail.samba.org ([66.70.73.150]:59581 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbZGANRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:17:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19019.25035.244941.352337@samba.org>
Date: Wed, 1 Jul 2009 23:16:59 +1000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090701123141.402c17d2@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<19019.16217.291678.588673@samba.org>
	<20090701123141.402c17d2@lxorguk.ukuu.org.uk>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

 > They don't have to ship the code. They can rip it out. They deal with
 > video players the same way for the USSA market and have done for years.

yes, vendors can make the patch unconditional of course. I thought
that we were not trying to encourage divergance between the kernel.org
tree and the vendor trees though? I know some divergance is always
going to happen, but it seems counter productive to be encouraging it.

 > Its a standard usage pattern for some people. Think about Linux based
 > commodity devices such as the N770 and plugging it into the users general
 > purpose PC box. Whenever it got pulled out wrongly it *will* get a chkdsk
 > in Windows.

really? I haven't noticed that behaviour for removable devices in
windows. You can manually set a drive to be checked on reboot, but I
wasn't aware of any automatic chkdsk mechanism for VFAT removable
media in windows. Have you seen this yourself?

In testing this patch I've pulled USB keys in and out of WinXP, Vista
and Windows7 hundreds of time, and done it programatically millions of
times via scripting on virtual machines, but I never noticed this
feature. Perhaps it happens only under some specific circumstances I
haven't seen?

 > >     Linux and Windows, I thought that this is not a terribly large
 > >     concern.
 > 
 > Disagree. Its a rapidly growing market segment.

you chopped off a word or two in the quote :-)

Of course I care about Linux/Windows interop, as I'm sure you know!
What I'm saying is that running chkdsk on a shared removable media
which contains 30k files in a single directory is not a common event,
and even when it does happen the consequences are that approximately
one in 3 times you do this, one of those 30k files gets renamed.

As evidence for this I'd like to point out that windows chkdsk has
complained about the Linux VFAT implementation for a long time, even
without my patch. If you create a filesystem with mformat and then
chkdsk it on windows you get:

  Bad links in lost chains at cluster 2 corrected
  Convert lost chains to files (Y/N)

yet I can't find a single instance of anyone complaining about this
with a google search. If a chkdsk was automated for removable media
then a lot of peoples machines would be asking them this question a
lot of the time. If people manually ran windows chkdsk on removable
VFAT media created on Linux then they also would have hit this and I
would have expected at least someone to have mentioned it.

Cheers, Tridge

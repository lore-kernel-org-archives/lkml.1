Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZGBWHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZGBWHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZGBWHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:07:07 -0400
Received: from mail.samba.org ([66.70.73.150]:40162 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbZGBWHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:07:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19021.12158.915384.574218@samba.org>
Date: Fri, 3 Jul 2009 08:06:54 +1000
To: Pavel Machek <pavel@ucw.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090702214646.GD1485@ucw.cz>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090702214646.GD1485@ucw.cz>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

 > > I disagree with this: given there's been testing with no known issues, it's 
 > > not a back compat question.
 > 
 > The testing uncovered some pretty serious issues. ('Causes XP to
 > bluescreen').

no, that's not quite correct. I have never been able to produce a
bluescreen with the patch I have posted.

I did manage to produce a bluescreen with a different patch that
deliberately lowers the number of bits of randomness used (ie. just
change the mask to random32() in vfat_build_dummy_83_buffer()). Even
then, producing a bluescreen is not trivial, though it is definately
possible.

As I explained in a previous posting, the WindowsXP bug doesn't happen
just because two 8.3 entries have the same 11 bytes. There are
additional strong constraints on the access patterns by the WindowsXP
kernel before the bluescreen happens. I reproduced it by running 4
processes in parallel doing massive numbers of random file operations,
with a controlling script transferring control of the USB key between
the WindowsXP box and a Linux host every minute (so both are doing
random file operations).

Even with that, if I had even a few bits of randomness then it took a
lot of testing (often hours) to produce the bluescreen. I wouldn't
have even known the problem was possible if I hadn't been
experimenting with patch varients where all the bytes are always the
same (such as the 11 spaces varient I mentioned). With those varients
(where there is no randomness at all), you can produce a bluescreen
with a bit of effort on the DOS command line.

So I hope you can see why I don't think this is a particularly large
problem, especially given that the WindowsXP FAT driver is notoriously
prone to crashing, as a quick google search will show you.

If someone can actually demonstrate the bluescreen with the patch I've
posted in some access pattern that is at all likely to be made by a
WindowsXP user then I would be more concerned. As it is, I don't think
we should hold off on this patch for what amounts to a theoretical
issue.

Cheers, Tridge

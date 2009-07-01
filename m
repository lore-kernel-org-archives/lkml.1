Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZGALMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZGALMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZGALMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:12:00 -0400
Received: from mail.samba.org ([66.70.73.150]:45874 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbZGALL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:11:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19019.17531.349844.201397@samba.org>
Date: Wed, 1 Jul 2009 21:11:55 +1000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090701110934.2f43591c@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<20090701110934.2f43591c@lxorguk.ukuu.org.uk>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

 > > What happens on collision? With 60000 entries in directory, there will
 > > be 50% chance of collision. BAD.
 > 
 > Far more surely - its a birthday paradox.

If you want to do it accurately, the maximum number of long filenames
in a VFAT directory is actually 32767. (it isn't 65536, as each long
filename consumes at least two 8.3 entries, plus you lose the . and
.. entries).

With the patch I've posted there are 30 bits of randomness in each
entry. You could do an accurate binomial expansion to get the exact
probability, but a very good approximation using exponentiation comes
out as a 39.3% chance of a single duplicate appearing in a directory
that is fully populated.

As I mentioned to Pavel, this isn't the whole story though. To cause
the bluescreen the duplicate entries need to be accessed by WindowsXP
in quick succession in a particular pattern. This lowers the
probability a lot. Exactly how much is hard to estimate, but
experiments I've done with deliberately higher probabilities (ie. less
bits of randomness) show that the probability of the bluescreen is
_very_ low.

 > Agreed 100%. I'm also not sure it should be called "vfat" when operating
 > in this mode as it's not vfat any more - it needs a new name.

If the code differed significantly between the two implementations I'd
probably agree, but as the two are extremely close I think maintaining
a separate filesystem isn't worth it.

Cheers, Tridge

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759812AbZGIDYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbZGIDYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 23:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbZGIDYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 23:24:00 -0400
Received: from mail.samba.org ([66.70.73.150]:41365 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbZGIDX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 23:23:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19029.25281.239186.836650@samba.org>
Date: Thu, 9 Jul 2009 13:23:45 +1000
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <200907081339.59815.Martin@lichtvoll.de>
References: <19013.8005.541836.436991@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<200907081339.59815.Martin@lichtvoll.de>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan and Martin,

As promised, I have continued to investigate what is happening with
Win98, even though I don't think it is a high priority.

I've discovered two things that are interesting:

  1) the 11 spaces varient works pretty nicely with it

  2) the current dualnames patch works nicely if you change the first
  byte to a '~' instead of a space.

What seems to be happening is that Win98 either wants all spaces, or
it wants to see a '~' in the 8 byte prefix, after taking into account
nul termination. If it doesn't see this '~' then it doesn't even look
for a long name.

Cheers, Tridge

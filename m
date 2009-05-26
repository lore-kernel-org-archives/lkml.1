Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbZEZAkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbZEZAkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 20:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZEZAkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 20:40:39 -0400
Received: from mail.crca.org.au ([67.207.131.56]:56247 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbZEZAkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 20:40:39 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200905260045.33902.oliver@neukum.org>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <1243245907.16743.101.camel@nigel-laptop> <200905252343.23744.rjw@sisk.pl>
	 <200905260045.33902.oliver@neukum.org>
Content-Type: text/plain
Date: Tue, 26 May 2009 10:42:24 +1000
Message-Id: <1243298544.16743.164.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver.

On Tue, 2009-05-26 at 00:45 +0200, Oliver Neukum wrote:
> Am Montag, 25. Mai 2009 23:43:23 schrieb Rafael J. Wysocki:
> > > Oh, before I forget to mention and you ask - how to know what allowance
> > > for the drivers? I use a sysfs entry - the user then just needs to see
> > > what's needed on their first attempt, set up a means of putting that
> > > value in the sysfs file in future (eg /etc/hibernate/tuxonice.conf) and
> > > then forget about it.
> >
> > OK, this is reasonable.
> 
> No, I am afraid it is not. The average user has no clue. Even if that
> is not the problem, the user never knows for sure he has encountered
> the worst case. If you really have drivers that have exceptionally
> large memory requirements (eg. you need to copy video ram), you
> should tell the system through struct driver and do accounting at
> probe and removal of devices.

I'm not suggesting they should expect to know before trying. TuxOnIce
tells you how many were needed in the debugging info printk'd at the end
of a cycle. Add a margin (400 is generally more than adequate) and
you'll have the number you're after:

TuxOnIce debugging info:
- TuxOnIce core  : 3.0.2
- Kernel Version : 2.6.30-rc6
- Compiler vers. : 4.3
- Attempt number : 8
- Parameters     : 0 667656 0 1 0 4
- Overall expected compression percentage: 45.
- Max outstanding reads 1091. Max writes 1089.
  Memory_needed: 1024 x (4096 + 368 + 104) = 4677632 bytes.
  Free mem throttle point reached 0.
- SwapAllocator active.
  Swap available for image: 733753 pages.
- FileAllocator inactive.
- Compressor is 'lzo'.
  Compressed 3215572992 bytes into 1121302124 (65 percent compression).
- I/O speed: Write 119 MB/s, Read 120 MB/s.
- Extra pages    : 832 used/2000.
- Result         : Succeeded.

Regards,

Nigel


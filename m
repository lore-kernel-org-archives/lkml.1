Return-Path: <linux-kernel-owner+w=401wt.eu-S1161280AbXCNOMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161280AbXCNOMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 10:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161282AbXCNOMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 10:12:55 -0400
Received: from csclub1.cs.uwaterloo.ca ([129.97.7.226]:60479 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161280AbXCNOMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 10:12:54 -0400
Date: Wed, 14 Mar 2007 10:12:53 -0400
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       Russell King <rmk+lkml@arm.linux.org.uk>, Jan Dittmer <jdi@l4x.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
Message-ID: <20070314141253.GM22464@csclub.uwaterloo.ca>
References: <20070216185230.GO8882@enneenne.com> <20070313213842.GA23178@enneenne.com> <20070313224817.GF22466@csclub.uwaterloo.ca> <20070314093146.GE24556@enneenne.com> <20070314131934.GL22464@csclub.uwaterloo.ca> <20070314140623.GF3802@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314140623.GF3802@enneenne.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 03:06:23PM +0100, Rodolfo Giometti wrote:
> Some fixes up... see the git log for further info.

I looked at those, and they didn't sound important.  I will grab it
anyhow just for completeness.

> Unluckely you need a patched version of setserial (see the patch on my
> site). On the same site you can find a precompiled version which I use
> for my tests, maybe it works for you...

OK, that explains why it wasn't in setserial's code.

> This is a specific problem of NTPD not of LinuxPPS itself. I wrote
> some letters about this problem into NTP list but with no results.
> 
> The sysadm shoulkd use setserial to enable a serial port to become a
> PPS source and then NTPD should verify if such PPS source exists
> (using time_pps_findpath() & Co.).

Well I think I may just write a small tool to do the ioctl to enable it
so I don't need the full setserial around.

> Did you read this example on the wiki?
> 
>    giometti@jeeg:~/linuxpps$ cat /sys/class/pps/01/name
>    serial1 
>    giometti@jeeg:~/linuxpps$ cat /sys/class/pps/01/path
>    /dev/ttyS1 
>    giometti at jeeg:~/linuxpps/test$ sudo ln -sf /dev/ttyS1 /dev/gps0
>    giometti at jeeg:~/linuxpps/test$ sudo ./ppstest /dev/gps0
>    found PPS source #2 "serial1" on "/dev/ttyS1"
>    giometti at jeeg:~/linuxpps/test$ sudo ln -sf ktimer /dev/gps0
>    giometti at jeeg:~/linuxpps/test$ sudo ./ppstest /dev/gps0
>    found PPS source #0 "ktimer" on ""
> 
> it doesn't work for you?

I will have to try that again to be sure.  I may have got myself
confused when I first tried it.  One symlink I can deal with (that's
ntpd sillyness after all).

--
Len Sorensen

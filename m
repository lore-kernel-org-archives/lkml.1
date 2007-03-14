Return-Path: <linux-kernel-owner+w=401wt.eu-S1030870AbXCNOGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030870AbXCNOGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 10:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030869AbXCNOGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 10:06:06 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:35476 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030870AbXCNOGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 10:06:03 -0400
Date: Wed, 14 Mar 2007 15:06:23 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       Russell King <rmk+lkml@arm.linux.org.uk>, Jan Dittmer <jdi@l4x.org>,
       Pavel Machek <pavel@ucw.cz>
Message-ID: <20070314140623.GF3802@enneenne.com>
References: <20070216185230.GO8882@enneenne.com> <20070313213842.GA23178@enneenne.com> <20070313224817.GF22466@csclub.uwaterloo.ca> <20070314093146.GE24556@enneenne.com> <20070314131934.GL22464@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314131934.GL22464@csclub.uwaterloo.ca>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 09:19:34AM -0400, Lennart Sorensen wrote:
> 
> I will grab the last couple of commits and try although they didn't
> sound like they really make much difference.

Some fixes up... see the git log for further info.

> I couldn't find any way to do that with setserial (at least not the
> version I have), and I would rather not have to install setserial just
> to do that.  Which version of setserial is needed and what arguments
> does it need to do it?

Unluckely you need a patched version of setserial (see the patch on my
site). On the same site you can find a precompiled version which I use
for my tests, maybe it works for you...

> If it is NOT connected to the same device, then how would you specify
> it?  The ntp configuration is rather sparse when it comes to specifying
> anything and seems to rely in symlinks to hardcoded device names for
> finding everything.  I suppose one could have gps# for the nmea messages
> and pps# for the associated pps device name symlink (which may point
> to something that doesn't even exist if there is an internal source of
> that name with no associated device).  Does that seem reasonable?  I can
> certainly change it to do that.  Certainly refclock_atom already uses
> /dev/pps# as it's device, so using that again may be reasonable.

This is a specific problem of NTPD not of LinuxPPS itself. I wrote
some letters about this problem into NTP list but with no results.

The sysadm shoulkd use setserial to enable a serial port to become a
PPS source and then NTPD should verify if such PPS source exists
(using time_pps_findpath() & Co.).

> I actually find the way it determines the pps device a bit annoying.
> Right now I have to do this:
> 
> cd /dev
> ln -s ttyn0 jsm0
> ln -s jsm0 gps0
> 
> This way gps0 is the symlink the ntp refclock looks for when asked for
> device 0, and readlink turns that into jsm0 (since the internal driver
> name for ttyn0 is jsm, that is what the pps code insists it must be
> named), which then is another symlink to the real device name.  Same for
> ttyS3 <- serial3 <- gps0.  Now it would be nice if the internal driver
> name matched the device name, but apparently that really never seems to
> happen.  Is all this symlink spagheti really necesary?

Did you read this example on the wiki?

   giometti@jeeg:~/linuxpps$ cat /sys/class/pps/01/name
   serial1 
   giometti@jeeg:~/linuxpps$ cat /sys/class/pps/01/path
   /dev/ttyS1 
   giometti at jeeg:~/linuxpps/test$ sudo ln -sf /dev/ttyS1 /dev/gps0
   giometti at jeeg:~/linuxpps/test$ sudo ./ppstest /dev/gps0
   found PPS source #2 "serial1" on "/dev/ttyS1"
   giometti at jeeg:~/linuxpps/test$ sudo ln -sf ktimer /dev/gps0
   giometti at jeeg:~/linuxpps/test$ sudo ./ppstest /dev/gps0
   found PPS source #0 "ktimer" on ""

it doesn't work for you?

> Will do.

Thanks a lot,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127

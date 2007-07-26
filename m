Return-Path: <linux-kernel-owner+w=401wt.eu-S933438AbXGZP2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438AbXGZP2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbXGZP2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:28:02 -0400
Received: from fw01.cmbrmaks.akamai.com ([80.67.64.10]:55518 "EHLO
	smtp2.akamai.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757768AbXGZP2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:28:00 -0400
X-Greylist: delayed 681 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2007 11:28:00 EDT
Message-ID: <46A8BAD4.8020004@akamai.com>
Date: Thu, 26 Jul 2007 11:16:36 -0400
From: Kyle Rose <krose@akamai.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sk98lin for 2.6.23-rc1
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From http://www.krose.org/~krose/computing.html:

Since the sky2 driver continues to suck ass (which is a technical
description for "it hangs all the time under load, at least on my
hardware" :-) ), I've fixed the sk98lin driver to compile for
linux-2.6.23-rc1. Those who continue to have problems with sky2 can
still use 2.6.23-rc1, simply by doing the following:

   1.

      Make sure you have the headers for your kernel properly installed
      and linked to /usr/src/linux-$KVER.

   2.

      Download the sk98lin source from Marvell's site
      <http://www.marvell.com/drivers/search.do>.

   3.

      Untar the driver and run the install.sh according to the
      directions. It will fail.

   4.

      Look in /tmp for a directory called Sk98something. Go to
      http://www.krose.org/~krose/projects/sk98lin/ and copy the
      Makefile <http://www.krose.org/%7Ekrose/projects/sk98lin/Makefile>
      and sky2.c <http://www.krose.org/%7Ekrose/projects/sk98lin/sky2.c>
      into /tmp/Sk98something/all.

   5.

      Change into /tmp/Sk98something/all and execute:

          sudo -H make -C /usr/src/linux-$KVER M=`pwd` modules
          sudo -H make -C /usr/src/linux-$KVER M=`pwd` modules_install

   6.

      Blacklist sky2 in /etc/modprobe.d/blacklist, and (maybe not
      necessary) manually load sk98lin in /etc/modules.

There. You're done. Stable networking at last... er, again.

Unfortunately, you lose the nicest differential feature of
sky2---WOL---but that's a small price to pay for networking stability of
a desktop machine. It's nice to be able to watch MythTV again without
having to sudo bash -c 'ifdown eth0; rmmod sky2; modprobe sky2; ifup
eth0' every few minutes.


Personally, I'd like to see sk98lin remain in the kernel proper until
sky2 goes at least 6 months without reported problems.  The fact that I
am not the only one still seeing issues is a clear indication that sky2
(even with the recent patches in 2.6.23-rc1) is not yet ready to replace
sk98lin.

I'm happy to help debug the remaining issues with sky2, Stephen; just
let me know what information you need.

Kyle


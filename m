Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbYJVN3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbYJVN3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYJVN3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:29:06 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49630 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbYJVN3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:29:05 -0400
To: linux-kernel@vger.kernel.org
Subject: e1000e fails after several S3 resumes (2.6.26 Debian, TP T60)
X-Mailer: MH-E 8.1; nmh 1.2; GNU Emacs 22.2.1
Date: Wed, 22 Oct 2008 09:28:58 -0400
From: Sanjoy Mahajan <sanjoy@MIT.EDU>
Message-Id: <E1Ksdli-0005Os-MP@approx.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once in a while after resuming from S3 sleep, the Ethernet driver
gets confused, whereupon dhcp'ing for an IP address fails, e.g.

  /* doing the dhcp: */
  Listening on LPF/eth0/00:16:41:52:50:de
  Sending on   LPF/eth0/00:16:41:52:50:de
  Sending on   Socket/fallback
  DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 7
  /* and so on with various intervals */

I workaround it with

  modprobe -rv e1000e ; modprobe -v e1000e
(the '-v' options to make sure the module does vanish and return)

and then try again to get an address, which works.  A similar failure
mode happens with the iwl3945 driver (and a similar workaround usually
succeeds).

How can I debug this issue the next time that it happens (it's about
once every two weeks)?  Using 'ethtool' or 'lspci -vvvv'?

  $ uname -a
  Linux approx 2.6.26-1-686 #1 SMP Thu Oct 9 15:18:09 UTC 2008 i686 GNU/Linux

It's Debian unstable's kernel 2.6.26 based on 2.6.26.4.  The laptop is a
Thinkpad T60 whose network controllers are given by lspci as

  02:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
  03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)

Could it be caused by the kernel (and modules) getting upgraded
underneath a running system?  In which case I'll just 'not do that
again' as the simplest fix, and reboot after a kernel upgrade.  My
installed kernel is based on 2.6.26.6, but the running kernel is based
on 2.6.26.4 [where based on means 'with Debian's patches'].

Please CC me on any responses.

-Sanjoy

`Until lions have their historians, tales of the hunt shall always
 glorify the hunters.'  --African Proverb

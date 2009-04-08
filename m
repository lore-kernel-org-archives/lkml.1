Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbZDHEyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbZDHEyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 00:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZDHEyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 00:54:31 -0400
Received: from fmailhost03.isp.att.net ([207.115.11.53]:38921 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZDHEya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 00:54:30 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49DC2DF5.3010603@lwfinger.net>
Date: Tue, 07 Apr 2009 23:54:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       wireless <linux-wireless@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Regression in 2.6.30-rc1 since commit acae0515 - wireless broken
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The most recent pulls of the Linux-2.6 git tree has broken wireless. The problem
was bisected with commit acae05156551fd7528fbb616271e672789388e3c, entitled
"module: create a request_module_nowait()", indicated as the faulty change. This
is seen with driver b43 on my system, and 2 reports for driver iwlagn:
http://marc.info/?l=linux-wireless&m=123916157630571&w=2 and
http://marc.info/?l=linux-wireless&m=123913015021457&w=2.

For b43, the logged error messages are:

phy0: Failed to initialize wep: -2
b43: probe of ssb0:0 failed with error -2

With this driver, module ssb is selected from the PCI ID. It then loads b43,
which triggers the loading of rfkill, mac80211, cfg80211, led-class, and
input-polldev. It appears that the nowait method is killing the chain somewhere.
If I unload and reload b43, then all these modules load correctly and wireless
works.

If this commit is reverted, wireless works OK.

I will be happy to try any patches to make request_module_nowait() work with
wireless networking.

Larry



Return-Path: <linux-kernel-owner+w=401wt.eu-S1759690AbYFCUq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690AbYFCUq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758311AbYFCUi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:38:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47088
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbYFCUgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:36:53 -0400
Date: Tue, 03 Jun 2008 12:19:51 -0700 (PDT)
Message-Id: <20080603.121951.193695839.davem@davemloft.net>
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, mokuno@sm.sony.co.jp, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/12]: Proper compat WEXT support.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a refresh of my previous WEXT compat patch set.

I've actually tested these exact patches on sparc64 with a RNDIS based
USB wireless device from Linksys.  I was able to perform iwconfig
commands, check iwlist, bring up the interface and use it properly.
All with 32-bit tools.  I've also done an allmodconfig sanity
build check on sparc64.

The one thing I was not able to test yet is wpa_supplicant use, and
that likely doesn't work properly yet, but we can fix that on top and
these patches do not break native non-compat binaries.  They do make a
lot of compat stuff work which wasn't the case before.  So applying
this stuff makes sense, and we can get wpa_supplicant working if it
isn't working using follow-on patches.

The patch set starts by cleaning up the code so that we can avoid
having multiple copies of the WEXT main dispatch routines, one for
compat and one for the non-compat case.

Next, basic compat level handling of the WEXT ioctl is added, and the
equivalent code in the compat_ioctl.c file is removed.

Finally, compat IWE stream munging is added for the wireless layer.
When we get a compat WEXT ioctl request, we set a bit in the request
info blob, and the stream building helpers tip off this to format the
stream entries properly.

These patches are against net-next-2.6 and are also available as
a GIT tree at:

	master.kernel.org:/pub/scm/linux/kernel/git/davem/wireless-2.6.git

John, please pull or apply as you deem appropriate.

Thanks!

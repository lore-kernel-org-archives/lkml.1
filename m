Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbYIJO6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbYIJO6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYIJO6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:58:10 -0400
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:26163 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbYIJO6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:58:09 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Time travel experiment?
Date: Wed, 10 Sep 2008 16:58:06 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101658.06935.elendil@planet.nl>
X-OriginalArrivalTime: 10 Sep 2008 14:58:07.0444 (UTC) FILETIME=[A264E940:01C91355]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After resuming my system today I noticed that the system time was off.
By 16 years...

$ date
Wed Jul  3 23:09:23 CEST 2024

The kernel log clearly shows the jump happening during a resume:
Sep 10 15:31:41 aragorn kernel: PM: Finishing wakeup.
Sep 10 15:31:41 aragorn kernel: Restarting tasks ... done.
Sep 10 15:31:41 aragorn kernel: wlan0: authenticate with AP 00:14:c1:38:e5:15
Sep 10 15:31:41 aragorn kernel: PM: Adding info for No Bus:vcs63
Sep 10 15:31:41 aragorn kernel: PM: Adding info for No Bus:vcsa63
Sep 10 15:31:41 aragorn kernel: wlan0: authenticated
Sep 10 15:31:41 aragorn kernel: wlan0: associate with AP 00:14:c1:38:e5:15
Sep 10 15:31:41 aragorn kernel: wlan0: RX ReassocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=1)
Sep 10 15:31:41 aragorn kernel: wlan0: associated
Sep 10 15:31:41 aragorn kernel: PM: Removing info for No Bus:vcs63
Sep 10 15:31:41 aragorn kernel: PM: Removing info for No Bus:vcsa63
Jul  3 23:09:08 aragorn kernel: wlan0: deauthenticated
Jul  3 23:09:09 aragorn kernel: wlan0: authenticate with AP 00:14:c1:38:e5:15
Jul  3 23:09:09 aragorn kernel: wlan0: authenticated
Jul  3 23:09:09 aragorn kernel: wlan0: associate with AP 00:14:c1:38:e5:15
Jul  3 23:09:09 aragorn kernel: wlan0: RX ReassocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=1)
Jul  3 23:09:09 aragorn kernel: wlan0: associated

I can find no other clues about the jump in my logs.

Running 2.6.27-rc6. Clock source is hpet.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYFTCx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYFTCx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 22:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYFTCxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 22:53:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37282 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYFTCxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 22:53:18 -0400
Message-ID: <485B1B8E.1060108@jp.fujitsu.com>
Date: Fri, 20 Jun 2008 11:53:02 +0900
From: Taku Izumi <izumi.taku@jp.fujitsu.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
CC: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, auke-jan.h.kok@intel.com
Subject: [PATCH 0/3] e1000,e1000e,igb: make ioport free for adapters that
 need NO ioport resources
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Only a few Intel Gigabit Adapters need ioport resources for workaround,
but most do not need them. Most adapters work properly without them.
In the case where ioport resources are not assigned to adapters, this can
happen on the large system, drivers' probe function fails like the following,
and adapters can not be used as a result.

 e1000e 0002:22:00.0: device not available because of BAR 2 [0:1f] collisions
 e1000e: probe of 0002:22:00.0 failed with error -22

These patches corrects behavior in probe function so as not to request ioport
resources as long as they are not really needed. These are based on the
ioport-free patch of e1000 driver from Auke Kok and Tomohiro Kusumi.

* [PATCH 1/3] e1000: make ioport free
* [PATCH 2/3] e1000e: make ioport free
* [PATCH 3/3] igb: make ioport free

Best regards,
Taku Izumi <izumi.taku@jp.fujitsu.com>



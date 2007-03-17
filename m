Return-Path: <linux-kernel-owner+w=401wt.eu-S933193AbXCQBvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbXCQBvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 21:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbXCQBvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 21:51:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30232 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193AbXCQBvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 21:51:31 -0400
Date: Fri, 16 Mar 2007 18:49:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: isdn4linux@listserv.isdn4linux.de, lkml <linux-kernel@vger.kernel.org>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de
Subject: is SpellCaster ISDN still used?
Message-Id: <20070316184955.71ff1e3b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There is an API argument mismatch in it:

drivers/isdn/sc/init.c:281: warning: assignment from incompatible pointer type

		interface->writebuf_skb = sndpkt;

where:

int sndpkt(int devId, int channel, struct sk_buff *data)
{
...
}

should look like this:

  /*
   * Send data using sk_buff's
   * Parameters:
   *             int                    driverId
   *             int                    local channel-number (0...)
   *             int                    Flag: Need ACK for this packet.
   *             struct sk_buff *skb    Data to send
   */
  int (*writebuf_skb) (int, int, int, struct sk_buff *);


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

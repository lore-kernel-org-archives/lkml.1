Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbYGZFPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbYGZFPr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 01:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYGZFPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 01:15:39 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:55554 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbYGZFPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 01:15:38 -0400
Message-ID: <488AB2F4.7060806@lwfinger.net>
Date: Sat, 26 Jul 2008 00:15:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       barry bouwsma <free_beer_for_all@yahoo.com>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Regression in 2.6.26-gitX: failure of wireless due to commit 175f9c1bba9b825d22b142
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wireless communication has failed for recent 2.6.26-gitX kernels - a definite 
regression. The logs show sequences such as:

eth1: authenticate with AP 00:1a:70:46:ba:b1
eth1: authenticate with AP 00:1a:70:46:ba:b1
eth1: authenticated
eth1: associate with AP 00:1a:70:46:ba:b1
eth1: associate with AP 00:1a:70:46:ba:b1
eth1: associate with AP 00:1a:70:46:ba:b1
eth1: association with AP 00:1a:70:46:ba:b1 timed out

I have this problem with b43 and p54usb, and there is at least one report of the 
same problem with zd1211rw. In my case, the encryption method is WPA-PSK/TKIP. I 
have not tested with WEP or unencrypted networks.

Bisection yields the following:

175f9c1bba9b825d22b142d183c9e175488b260c is first bad commit
commit 175f9c1bba9b825d22b142d183c9e175488b260c
Author: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date:   Sun Jul 20 00:08:47 2008 -0700

     net_sched: Add size table for qdiscs

     Add size table functions for qdiscs and calculate packet size in
     qdisc_enqueue().

     Based on patch by Patrick McHardy
      http://marc.info/?l=linux-netdev&m=115201979221729&w=2

     Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
     Signed-off-by: David S. Miller <davem@davemloft.net>

========================================================

I tried to reverse apply the patch; however, that does not happen cleanly, but I 
am confident that the problem arises here. I don't understand enough about this 
qdisc stuff to even guess at what might be wrong.

As always, I am willing to test any trial patches, etc.

Thanks,

Larry

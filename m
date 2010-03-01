Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab0CAMJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 07:09:37 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53350 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab0CAMJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 07:09:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B8BAE79.9000609@s5r6.in-berlin.de>
Date: Mon, 01 Mar 2010 13:09:29 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: sparse checking prevented by "net: fix kmemcheck annotations"
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

the post 2.6.32-rc5, pre 2.6.32-rc6 commit 14d18a81 causes a serious
regression for sparse checks:  make C=1 CF="-D__CHECK_ENDIAN__" now
causes sparse to log

    include/linux/skbuff.h:357:41: error: invalid bitfield specifier for
    type restricted __be16.


I reported this already shortly after this hit the mainline.  But back
then I didn't notice that this sparse error causes sparse to remain
silent on all subsequent warnings in a file!

We need to either change sparse to accept this bogus bit field that
occurs in skbuff.h (__be16 protocol:16;), silently or with a warning, or
revert this kmemcheck annotation.

("We" == preferably Eric :-)

skbuff.h is included by lots of drivers, even ones that are not even
networking drivers, notably DVB drivers.  None of these drivers can be
checked with sparse's __CHECK_ENDIAN__ at the moment.
-- 
Stefan Richter
-=====-==-=- --== ----=
http://arcgraph.de/sr/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758484AbYH3J2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbYH3J2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 05:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYH3J21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 05:28:27 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:44013 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbYH3J20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 05:28:26 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc5 nfs stall - more info
Date: Sat, 30 Aug 2008 19:28:11 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <vv3ib45u20ra8o8sc6cng5bd2drdqv733a@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Had another stall, server running 2.6.24.7, clients running 2.6.27-rc5.

On the server the netstat -t gave during stall:

grant@deltree:~$ netstat -t
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 localhost:50087         localhost:4743          ESTABLISHED
tcp        0     52 deltree.mire.mine.n:ssh sillywin.mire.mine:3052 ESTABLISHED
tcp        0      0 deltree.mire.mine.n:ssh sillywin.mire.mine:3051 ESTABLISHED
tcp        0      0 deltree.mire.mine.n:ssh sillywin.mire.mine:1056 ESTABLISHED
tcp        0      0 localhost:4743          localhost:50087         ESTABLISHED


after stall, shows the delay seems to be in making the NFS connection:
grant@deltree:~$ netstat -t
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 localhost:50087         localhost:4743          ESTABLISHED
tcp        0      0 deltree.mire.mine.n:ssh sillywin.mire.mine:3052 ESTABLISHED
tcp        0      0 deltree.mire.mine.n:ssh sillywin.mire.mine:3051 ESTABLISHED
tcp        0      0 deltree.mire.mine.n:ssh sillywin.mire.mine:1056 ESTABLISHED
tcp        0      0 localhost:4743          localhost:50087         ESTABLISHED
tcp        0      0 deltree.mire.mine.:nfsd pooh.mire.mine.nu:rtip  ESTABLISHED


On 'pooh', I opened a new root terminal and run a command from nfs 
export from deltree, this is when the stall happened, pooh had been 
up for about five hours, this from /var/log/messages:
Aug 30 19:10:21 pooh sshd[2615]: Accepted publickey for root from 192.168.1.36 port 1246 ssh2


Just before doing that I'd told 'tosh' to halt via ssh terminal 
and the server recorded in /var/log/messages:
Aug 30 19:11:03 deltree mountd[573]: authenticated unmount request from tosh.mire.mine.nu:680 for /home/common (/home/common)

Just coincidence?
.config + dmesg for the clients (.27-rc5a):
  http://bugsplatter.id.au/kernel/boxen/pooh/
  http://bugsplatter.id.au/kernel/boxen/toshi/
server (.24.7a):
  http://bugsplatter.id.au/kernel/boxen/deltree/

Grant.

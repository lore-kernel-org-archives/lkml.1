Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000Ab0A0VLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0A0VLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 16:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944Ab0A0VLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 16:11:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab0A0VLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 16:11:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/3 v3] macvtap driver
Date: Wed, 27 Jan 2010 11:04:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Patrick McHardy <kaber@trash.net>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Or Gerlitz <ogerlitz@voltaire.com>, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Message-Id: <201001271104.20607.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18X73SZ0i/FbR+dIpNG0Ni+9RCoESACoa01TlW
 EA81AL6uUiQSGM6oYYE80iTfOq9p2Tq/2ytkG8TeFLHNKBLUtQ
 /UDoOl8VeCEKc5vCT4KNA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third version of the macvtap device driver, following another major restructuring and a lot of bug fixes:

* Change macvtap to be based around a struct sock
* macvtap: fix initialization
* return 0 to netlink
* don't use rcu for q->file and q->vlan pointers
* macvtap: checkpatch.pl fixes
* macvtap: fix tun IFF flags
* Use a struct socket to make tx flow control work
* disable BH processing during transmit
* only add an ethernet header for receive not forward
* allocate the SKB using GFP_NOWAIT since we're
  in rcu_read_lock
* use atomic allocation for socket
* fix blocking on send
* do not destroy netdev twice in error path

There are still known problems, but unless there
are fundamental concerns, I'd like this to go
into net-next as an experimental driver,
fixing up the remaining problems by 2.6.34-rc1.

	Arnd

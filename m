Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbZINNVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbZINNVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbZINNVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:21:48 -0400
Received: from mail-a02.ithnet.com ([217.64.83.97]:35213 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753384AbZINNVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:21:47 -0400
X-Greylist: delayed 671 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Sep 2009 09:21:47 EDT
X-Sender-Authentication: net64
Date: Mon, 14 Sep 2009 15:09:35 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net
Subject: ipv4 regression in 2.6.31 ?
Message-Id: <20090914150935.cc895a3c.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

today we experienced some sort of regression in 2.6.31 ipv4 implementation, or
at least some incompatibility with former 2.6.30.X kernels.

We have the following situation:

                                       ---------- vlan1@eth0 192.168.2.1/24
                                      /
host A 192.168.1.1/24 eth0  -------<router>            host B
                                      \
                                       ---------- eth1 192.168.3.1/24


Now, if you route 192.168.1.0/24 via interface vlan1@eth0 on host B and let
host A ping 192.168.2.1 everything works. But if you route 192.168.1.0/24 via
interface eth1 on host B and let host A ping 192.168.2.1 you get no reply.
With tcpdump we see the icmp packets arrive at vlan1@eth0, but no icmp echo
reply being generated neither on vlan1 nor eth1.
Kernels 2.6.30.X and below do not show this behaviour.
Is this intended? Do we need to reconfigure something to restore the old
behaviour?

-- 
Regards,
Stephan


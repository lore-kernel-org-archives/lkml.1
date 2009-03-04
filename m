Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbZCDChb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbZCDChb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZCDChR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:37:17 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:30923 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZCDChQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:37:16 -0500
Message-ID: <49ADE956.1020702@hp.com>
Date: Tue, 03 Mar 2009 21:37:10 -0500
From: Brian Haley <brian.haley@hp.com>
Organization: Open Source and Linux Organization
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Andrey Borzenkov <arvidjaar@mail.ru>,
       Vladislav Yasevich <vladislav.yasevich@hp.com>,
       Chuck Lever <chuck.lever@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Valdis.Kletnieks@vt.edu, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       bonding-devel@lists.sourceforge.net,
       =?ISO-8859-1?Q?=22J=2EA=2E_Magall?= =?ISO-8859-1?Q?=F3n=22?= 
	<jamagallon@ono.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Vosburgh <fubar@us.ibm.com>
Subject: [PATCH 0/2] Bonding: fix IPv6 module requirement regression
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These patches fix the Bonding module's requirement to have the IPv6
module loaded and configured by creating a new "disable" module parameter
value for ipv6.ko.  This allows users who do not want any IPv6 addresses
or sockets to be created to disable IPv6 support, while still loading
the module and making it's symbols available.  This can be specified in
/etc/modprobe.conf (or similar) with "options ipv6 disable=1".

I've verified that Bonding, SCTP, Sunrpc and DCCP will still load, however
dccp_ipv6 will not load when disable=1 - I believe this is ok as
IPv6 won't work anyways.


  Documentation/networking/ipv6.txt |   35 +++++++++++++++++++++++++++++++++++
  net/ipv6/af_inet6.c               |   22 ++++++++++++++++------
  net/sctp/protocol.c               |   11 ++++++++---
  3 files changed, 59 insertions(+), 9 deletions(-)

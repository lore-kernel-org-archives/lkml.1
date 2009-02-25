Return-Path: <linux-kernel-owner+w=401wt.eu-S1763149AbZBYWPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763149AbZBYWPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:15:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762116AbZBYWOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:14:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34697
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759718AbZBYWOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:14:46 -0500
Date: Wed, 25 Feb 2009 14:14:30 -0800 (PST)
Message-Id: <20090225.141430.166906161.davem@davemloft.net>
To: fubar@us.ibm.com
Cc: brian.haley@hp.com, arvidjaar@mail.ru, vladislav.yasevich@hp.com,
       chuck.lever@oracle.com, tytso@mit.edu, Valdis.Kletnieks@vt.edu,
       rjw@sisk.pl, netdev@vger.kernel.org,
       bonding-devel@lists.sourceforge.net, jamagallon@ono.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] bonding: move IPv6 support into a separate kernel
 module
From: David Miller <davem@davemloft.net>
In-Reply-To: <28797.1235599858@death.nxdomain.ibm.com>
References: <49A5ADB3.2010709@hp.com>
	<28797.1235599858@death.nxdomain.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Vosburgh <fubar@us.ibm.com>
Date: Wed, 25 Feb 2009 14:10:58 -0800

> 	I've been fooling with the disable_ipv6 sysctl, and one issue is
> that, at least on the distro I'm testing on (SLES), it's not picked up
> from /etc/sysctl.conf at boot time (presumably because ipv6 isn't loaded
> yet, although I haven't really checked).

Correct, that's the problem.

We could create a blocker bitmap.  Two sysctls, "block_af" and
"unblock_af".  You write the AF_foo value for the protocol there and
it sets or clears the assosciated bit in the internal blocker bitmap.

Things like sys_socket() et al. key off of this.

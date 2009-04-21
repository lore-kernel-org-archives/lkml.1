Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbZDUTbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbZDUTbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZDUTaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:30:52 -0400
Received: from lixom.net ([66.141.50.11]:39085 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbZDUTav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:30:51 -0400
Date: Tue, 21 Apr 2009 14:33:19 -0500
From: Olof Johansson <olof@lixom.net>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: netdev <netdev@vger.kernel.org>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, themann@de.ibm.com,
       davem@davemloft.net
Subject: INET_LRO as tristate and use from modules (was: Re: [BUILD FAILURE
	08/12] Next April 21 : PPC64 randconfig
	[drivers/net/pasemi_mac_driver.ko])
Message-ID: <20090421193319.GB20237@lixom.net>
References: <1240339984.9110.141.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240339984.9110.141.camel@subratamodak.linux.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 12:23:03AM +0530, Subrata Modak wrote:
> Reported this on 9th April earlier:
> http://lkml.org/lkml/2009/4/9/276,
> 
> I hope the following Patch will solve this problem as well:
> Geoff Levand <geoffrey.levand@am.sony.com> provided a patch on 17th
> April.
> http://lkml.org/lkml/2009/4/17/313,

No, that's a separate issue.

>   MODPOST 338 modules
> ERROR: ".lro_receive_skb" [drivers/net/pasemi_mac_driver.ko] undefined!
> ERROR: ".lro_flush_all" [drivers/net/pasemi_mac_driver.ko] undefined!
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

This seems to be a problem with all tristate-capable drivers that use
LRO (and uses select INET_LRO in their Kconfig): INET_LRO is a tristate
and can thus be a module. Looks like it needs to be a bool instead?


-Olof


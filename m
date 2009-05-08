Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbZEHToJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbZEHToJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZEHTnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:43:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58070
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbZEHTnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:43:52 -0400
Date: Fri, 08 May 2009 12:43:47 -0700 (PDT)
Message-Id: <20090508.124347.142493836.davem@davemloft.net>
To: olof@lixom.net
Cc: subrata@linux.vnet.ibm.com, netdev@vger.kernel.org,
       geoffrey.levand@am.sony.com, Linuxppc-dev@ozlabs.org,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       sachinp@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       themann@de.ibm.com
Subject: Re: INET_LRO as tristate and use from modules
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090422.021218.92737677.davem@davemloft.net>
References: <1240339984.9110.141.camel@subratamodak.linux.ibm.com>
	<20090421193319.GB20237@lixom.net>
	<20090422.021218.92737677.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 22 Apr 2009 02:12:18 -0700 (PDT)

> From: Olof Johansson <olof@lixom.net>
> Date: Tue, 21 Apr 2009 14:33:19 -0500
> 
>> On Wed, Apr 22, 2009 at 12:23:03AM +0530, Subrata Modak wrote:
>>>   MODPOST 338 modules
>>> ERROR: ".lro_receive_skb" [drivers/net/pasemi_mac_driver.ko] undefined!
>>> ERROR: ".lro_flush_all" [drivers/net/pasemi_mac_driver.ko] undefined!
>>> WARNING: modpost: Found 1 section mismatch(es).
>>> To see full details build your kernel with:
>>> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>>> make[1]: *** [__modpost] Error 1
>>> make: *** [modules] Error 2
>> 
>> This seems to be a problem with all tristate-capable drivers that use
>> LRO (and uses select INET_LRO in their Kconfig): INET_LRO is a tristate
>> and can thus be a module. Looks like it needs to be a bool instead?
> 
> Yes, making this a bool would be the easiest fix.
> 
> By why don't we get the same problem for PHYLIB?  It's also
> tristate and "select"'d by a whole slew of networking drivers.

I guess nobody has any idea...

I'll just make INET_LRO a bool to fix this.

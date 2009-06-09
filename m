Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbZFIQQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbZFIQQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbZFIQPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:15:54 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45356 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbZFIQPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:15:53 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: Patrick McHardy <kaber@trash.net>
cc: Stephen Hemminger <shemminger@vyatta.com>, Arnd Bergmann <arnd@arndb.de>,
       "David S. Miller" <davem@davemloft.net>, bonding-devel@lists.sf.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: bonding module can only be loaded once
In-reply-to: <4A2E80B3.6010600@trash.net>
References: <20090608151127.70146505@nehalam> <200906091406.45463.arnd@arndb.de> <20090609080232.45f81833@nehalam> <4A2E80B3.6010600@trash.net>
Comments: In-reply-to Patrick McHardy <kaber@trash.net>
   message dated "Tue, 09 Jun 2009 17:33:07 +0200."
X-Mailer: MH-E 8.0.3; nmh 1.3-RC3; GNU Emacs 22.2.1
Date: Tue, 09 Jun 2009 09:14:42 -0700
Message-ID: <4752.1244564082@death.nxdomain.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy <kaber@trash.net> wrote:

>Stephen Hemminger wrote:
>>> --- a/drivers/net/bonding/bond_main.c
>>> +++ b/drivers/net/bonding/bond_main.c
>>> @@ -5203,7 +5203,7 @@ static int __init bonding_init(void)
>>>   	res = bond_create_sysfs();
>>>  	if (res)
>>> -		goto err;
>>> +		pr_info("Loading bonding module without sysfs interface\n");
>>>   	register_netdevice_notifier(&bond_netdev_notifier);
>>>  	register_inetaddr_notifier(&bond_inetaddr_notifier);
>>
>> That only makes it limp along, and there still are warnings.
>> The point is that who ever added the WARN() in proc and sysfs, effectively
>> broke a bonding usage model.
>
>It did already dump the stack before that change, didn't it?
>
>In any case, this is not the first time this has been broken and the
>fundamental reason is in my opinion that the bonding interface is
>broken to begin with. The module aliasing thing is complete crap
>and should have been phased out long ago. At this point its probably
>not worth anymore to migrate people to the sysfs interface though,
>the best thing would be to add an rtnl_link interface and phase out
>both.

	The "load bonding multiple times" stuff is only there now for
backwards compatibility with old distro initscripts / sysconfig packages
that don't configure bonding through sysfs (a sysfs API was added to
bonding three or four years ago).

	All of the current distro releases I'm aware of use sysfs to
configure bonding, and have done so for at least a year or two.  I
haven't done an exhaustive survey, but it seems unlikely that users are
running a current up to date kernel with a two or three year old
initscripts / sysconfig package.  Anybody have information to the
contrary?

	If nobody has any heartburn at dropping support for multiple
bonding instances on old distros, I'm as happy as anybody to remove all
of the multiple load logic from bonding.  There's been plenty of time
for transitioning from "multiple load" to sysfs.

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com

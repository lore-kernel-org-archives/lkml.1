Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbXFMLRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbXFMLRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 07:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758063AbXFMLRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 07:17:18 -0400
Received: from stinky.trash.net ([213.144.137.162]:60930 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054AbXFMLRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 07:17:16 -0400
Message-ID: <466FD17A.8040900@trash.net>
Date: Wed, 13 Jun 2007 13:14:02 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: cannot set IP for ethernet
References: <200706121441.13561.oliver@neukum.org> <466EA861.2070509@trash.net> <200706131039.32011.oliver@neukum.org>
In-Reply-To: <200706131039.32011.oliver@neukum.org>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Dienstag, 12. Juni 2007 schrieb Patrick McHardy:
> 
>>Oliver Neukum wrote:
>>
>>>with 2.6.22-rc4-git2 I am getting errors when setting IP for ethernet
>>>interfaces:
>>>
>>>ioctl(4, SIOCSIFADDR, 0x7fff94931600)   = -1 ENOBUFS (No buffer space available)
>>>
>>>The error is independant of the interface. It happens to all interfaces.
>>>There's nothing in the syslog.
>>>
>>>valisk:/home/oliver # uname -a
>>>Linux valisk 2.6.22-rc4-git2-default #3 SMP Tue Jun 12 13:27:54 CEST 2007 x86_64 x86_64 x86_64 GNU/Linux
>>
>>
>>This can happen if the initial inetdev allocation when the netdevice is
>>registered fails. I think it would make sense to try to allocate again
>>when adding addresses in that case, otherwise there is no way of
>>recovery other than unregistering and registering the device again.
> 
> 
> With your patch the problem has gone away. Is there a way to especially
> stress the system in that regard?


Its a failed allocation at NETDEV_REGISTER time. I guess you could
keep unloading + reloading the driver module to try to reproduce it.

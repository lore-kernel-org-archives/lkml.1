Return-Path: <linux-kernel-owner+w=401wt.eu-S966847AbXFGWJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966847AbXFGWJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966740AbXFGWHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:07:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966713AbXFGWHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:07:34 -0400
Date: Thu, 7 Jun 2007 15:06:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: jfannin@gmail.com (Joseph Fannin)
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
       netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.22-rc4-mm2: Assigning IP address fails
Message-Id: <20070607150653.b83bfc0f.akpm@linux-foundation.org>
In-Reply-To: <20070607214609.GB8204@nineveh.local>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	<20070607214609.GB8204@nineveh.local>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 17:46:09 -0400
jfannin@gmail.com (Joseph Fannin) wrote:

> On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> 
>     I'm not able to bring an ethernet interface down and back up again
> with this if avahi-autoipd is installed on my Ubuntu boxes.  I've seen
> it on three different computers with different NIC hardware.
> 
>     I've worked out an easy way to reproduce it without
> avahi-autoipd.  Starting with eth0 up (address assigned by DHCP):
> 
>   # ifdown eth0
>   < dhclient makes the normal noise about releasing the address >
>   # ip addr add 169.254.255.67/16 brd 169.254.255.255 label eth0:avahi scope link dev eth0
>   # ip addr del 169.154.255.67/16 brd 169.254.255.255 label eth0:avahi scope link dev eth0
>   # ifup eth0
>   SIOCSIFADDR: No buffer space available    < -- first sign of trouble HERE
>   < dhclient copyright boilerplate >
>   Listening on LPF/eth0/<MAC addr>
>   Sending on   LPF/eth0/<MAC addr>
>   Sending on   Socket/fallback
>   DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 5
>   DHCPOFFER from < DHCP server >
>   DHCPREQUEST on eth0 to 255.255.255.255 port 67
>   DHCPACK from  < DHCP server >
>   SIOCSIFADDR: No buffer space available
>   SIOCSIFNETMASK: Cannot assign requested address
>   SIOCSIFBRDADDR: Cannot assign requested address
>   SIOCADDRTL No such process
>   bound to < IP address > -- renewal in XXXX seconds
>   #
> 
>     At this point, the interface is up, but has no address assigned.
> Manually assigning one with ifconfig fails:
> 
>   # ifconfig eth0 netmask 255.255.255.0 172.16.0.1
>   SIOCSIFNETMASK: Cannot assign requested address
>   SIOCSIFADDR: No buffer space available
>   #
> 
> ... and a reboot is the only way I've been able to get the interface
> to work again.
> 
>     The last kernels I tried were 2.6.22-rc3 and *I think*
> 2.6.22-rc1-mm1, neither of which had this problem.  I will test
> 2.6.22-rc4 and 2.6.22-rc3-mm1 later, but I'm out of time today.
> 
>     I've attached my .config .

Yep, thanks - Miles has reported the same thing.

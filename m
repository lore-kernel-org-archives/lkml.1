Return-Path: <linux-kernel-owner+w=401wt.eu-S1763793AbXLMHYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763793AbXLMHYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761668AbXLMHN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 02:13:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46637 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763702AbXLMHN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 02:13:56 -0500
Date: Wed, 12 Dec 2007 23:08:29 -0800
From: Greg KH <greg@kroah.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: "Kyle A. Lucke" <klucke@us.ibm.com>, David Gibson <dwg@au1.ibm.com>,
       linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: drivers/net/iseries_veth.c dubious sysfs usage
Message-ID: <20071213070829.GA13764@kroah.com>
References: <20071205093054.GA23229@kroah.com> <1196853031.6759.7.camel@concordia> <20071205214103.GA7074@kroah.com> <1196912898.14754.13.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196912898.14754.13.camel@concordia>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 02:48:18PM +1100, Michael Ellerman wrote:
> igoeast:~# cd /sys/class/net/eth1/
> igoeast:/sys/class/net/eth1# ls -la
> total 0
> drwxr-xr-x  4 root root    0 Dec  6 10:22 .
> drwxr-xr-x  6 root root    0 Dec  6 10:21 ..
> -r--r--r--  1 root root 4096 Dec  6 10:30 addr_len
> -r--r--r--  1 root root 4096 Dec  6 10:30 address
> -r--r--r--  1 root root 4096 Dec  6 10:30 broadcast
> -r--r--r--  1 root root 4096 Dec  6 10:30 carrier
> lrwxrwxrwx  1 root root    0 Dec  6 10:22 device -> ../../../devices/vio/3
> -r--r--r--  1 root root 4096 Dec  6 10:30 dormant
> -r--r--r--  1 root root 4096 Dec  6 10:30 features
> -rw-r--r--  1 root root 4096 Dec  6 10:30 flags
> -r--r--r--  1 root root 4096 Dec  6 10:30 ifindex
> -r--r--r--  1 root root 4096 Dec  6 10:30 iflink
> -r--r--r--  1 root root 4096 Dec  6 10:30 link_mode
> -rw-r--r--  1 root root 4096 Dec  6 10:30 mtu
> -r--r--r--  1 root root 4096 Dec  6 10:30 operstate
> drwxr-xr-x  2 root root    0 Dec  6 10:30 statistics
> lrwxrwxrwx  1 root root    0 Dec  6 10:30 subsystem -> ../../../class/net
> -rw-r--r--  1 root root 4096 Dec  6 10:30 tx_queue_len
> -r--r--r--  1 root root 4096 Dec  6 10:30 type
> -rw-r--r--  1 root root 4096 Dec  6 10:30 uevent
> drwxr-xr-x  2 root root    0 Dec  6 10:30 veth_port
> 
> Each net device has a port structure associated with it, the fields
> should be fairly self explanatory, they're all read only I think.
> 
> igoeast:/sys/class/net/eth1# find veth_port/
> veth_port/
> veth_port/mac_addr
> veth_port/lpar_map
> veth_port/stopped_map
> veth_port/promiscuous
> veth_port/num_mcast

That's fine, I'll let you fight with the network people over that :)

> igoeast:/sys/class/net/eth1# cd device/driver
> 
> igoeast:/sys/class/net/eth1/device/driver# ls -l
> total 0
> lrwxrwxrwx  1 root root    0 Dec  6 10:21 2 -> ../../../../devices/vio/2
> lrwxrwxrwx  1 root root    0 Dec  6 10:21 3 -> ../../../../devices/vio/3
> --w-------  1 root root 4096 Dec  6 10:21 bind
> drwxr-xr-x  2 root root    0 Dec  6 10:21 cnx00
> drwxr-xr-x  2 root root    0 Dec  6 10:21 cnx02
> drwxr-xr-x  2 root root    0 Dec  6 10:21 cnx03
> drwxr-xr-x  2 root root    0 Dec  6 10:21 cnx04
> lrwxrwxrwx  1 root root    0 Dec  6 10:21 module -> ../../../../module/iseries_veth
> --w-------  1 root root 4096 Dec  6 10:21 uevent
> --w-------  1 root root 4096 Dec  6 10:21 unbind
> 
> The driver has a connection to all the other lpars, this is entirely
> independent of the net devices.
> 
> igoeast:/sys/class/net/eth1/device/driver# find cnx00/
> cnx00/
> cnx00/outstanding_tx
> cnx00/remote_lp
> cnx00/num_events
> cnx00/reset_timeout
> cnx00/last_contact
> cnx00/state
> cnx00/src_inst
> cnx00/dst_inst
> cnx00/num_pending_acks
> cnx00/num_ack_events
> cnx00/ack_timeout

Hm, ok, it's odd as you are the only driver in the whole tree doing
something like this, but it seems semi-resonable, so I can't complain :)

I'll fix the core up to allow you to do this, thanks for the
explanation.

greg k-h

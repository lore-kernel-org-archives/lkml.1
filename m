Return-Path: <linux-kernel-owner+w=401wt.eu-S1161097AbXBACKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161097AbXBACKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 21:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161086AbXBACKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 21:10:08 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:28421 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161082AbXBACKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 21:10:06 -0500
Message-ID: <45C14BF6.50309@chelsio.com>
Date: Wed, 31 Jan 2007 18:09:58 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Divy Le Ray <None@chelsio.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, swise@opengridcomputing.com
Subject: Re: [PATCH 1/10] cxgb3 - FW versioning
References: <20070131034345.8574.21031.stgit@localhost.localdomain> <45C07202.3090308@garzik.org>
In-Reply-To: <45C07202.3090308@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2007 02:10:01.0294 (UTC) FILETIME=[146D3EE0:01C745A6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

Please see my replies in line.
> You need to submit a patch to remove the following ioctls:
>
> CHELSIO_SETREG:
> CHELSIO_GETREG:

These will get removed.

> CHELSIO_SET_QSET_PARAMS: (use ethtool instead)
> CHELSIO_GET_QSET_PARAMS: (use ethtool instead)

The T3 adapter supports multiple Tx/Rx queue sets,
each can be can individually configured through these ioctls.

ethtool is not adequate replacement because it can't configure
each queue individually on such a device. We'd love it if ethtool
were to be extended to provide good support for multi queue devices.

> CHELSIO_SET_QSET_NUM: (use ethtool instead)
> CHELSIO_GET_QSET_NUM: (use ethtool instead)

These are used to set the number of queue sets per port.
That also could be integrated in ethtool if extended
to add support for multiple queue devices.
We could alternatively use a sysfs attribute.

> CHELSIO_SETMTUTAB:

This one is needed to setup the device for RDMA.

> CHELSIO_GET_MEM:

This one is used for field diagnostics.
It dumps the state of on-card memory.

> CHELSIO_SET_TRACE_FILTER:

This one is used for RDMA.
It allows to see the ethernet packets the RDMA function
puts on the wire/receives from the wire.

> CHELSIO_SET_PKTSCHED:

This one binds a queue set to a port.
It could be turned to a sysfs attribute.

>
> explain and possibly remove
>
> CHELSIO_GET_PM:
> CHELSIO_SET_PM:

These are used to configure the on-card memory (tx/rx size
and number of pages). They could be turned into sysfs attributes.

Cheers,
Divy

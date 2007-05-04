Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbXEDGlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbXEDGlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 02:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767688AbXEDGlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 02:41:50 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:34773 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbXEDGlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 02:41:49 -0400
Subject: Re: [PATCH] Bluetooth: postpone hci_dev unregistration
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0705021144291.21227@twin.jikos.cz>
References: <Pine.LNX.4.64.0705021144291.21227@twin.jikos.cz>
Content-Type: text/plain
Date: Fri, 04 May 2007 08:41:53 +0200
Message-Id: <1178260913.25425.27.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> (I sent this a week ago but it seems to have got lost in other noise, 
> resending)
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> Bluetooth: postpone hci_dev unregistration
>     
> Commit b40df57 substituted bh_lock_sock() in hci_sock_dev_event() for 
> lock_sock() when unregistering HCI device, in order to prevent deadlock 
> against locking in l2cap_connect_cfm() from softirq context.
>     
> This however introduces another problem - hci_sock_dev_event() for 
> HCI_DEV_UNREG can also be triggered in atomic context, in which calling 
> lock_sock() is not safe as it could sleep. Reported by Jeremy Fitzhardinge 
> at http://lkml.org/lkml/2007/4/23/271
> 
> This patch moves the detaching of sockets from hci_device into workqueue, 
> so that lock_sock() can be used safely. This requires movement of 
> deallocation of hci_dev - deallocating device just after 
> hci_unregister_dev() would be too soon, as it could happen before the 
> workqueue has been run.

I saw the report on LKML, but I am not really comfortable with this
approach. It feels like an ugly hack. This needs more thinking and I
think that simplifying the looking between HCI and L2CAP should be the
goal.

Regards

Marcel



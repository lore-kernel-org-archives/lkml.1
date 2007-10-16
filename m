Return-Path: <linux-kernel-owner+w=401wt.eu-S966570AbXJPWcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966570AbXJPWcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965890AbXJPWcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:32:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54419
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965897AbXJPWcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:32:42 -0400
Date: Tue, 16 Oct 2007 15:32:48 -0700 (PDT)
Message-Id: <20071016.153248.95506316.davem@davemloft.net>
To: greg@kroah.com
Cc: jens.axboe@oracle.com, kay.sievers@vrfy.org, rjw@sisk.pl,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       htejun@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071016213730.GB21815@kroah.com>
References: <20071016204238.GA1093@kroah.com>
	<20071016205053.GI9942@kernel.dk>
	<20071016213730.GB21815@kroah.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Tue, 16 Oct 2007 14:37:30 -0700

> Kay, are we doing something wrong in userspace when renaming wireless
> devices such that we can overlap names?

It does it for all network devices, I see this ugly message on every
single system I have from Fedora foo to RHEL foo to ubuntu foo to
debian foo.

udev simply applies the MAC address to device name rules blindly, it
doesn't check if the device already has the desired name already

It's been like this forever, and since userland has been doing it for
so long, you can't warn on this there is too much established
practice.  Expecting people to install "fixed" udev is not an
acceptable answer, the warning is a regression and therefore you'll
have to remove the kernel warning for this case and live with this
issue essentially forever.

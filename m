Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbXHHEhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbXHHEhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 00:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXHHEh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 00:37:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43275
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbXHHEh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 00:37:27 -0400
Date: Tue, 07 Aug 2007 21:37:24 -0700 (PDT)
Message-Id: <20070807.213724.27783161.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: Error message from device_rename in drivers/base/core.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <46B943D3.9020207@lwfinger.net>
References: <46B943D3.9020207@lwfinger.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Tue, 07 Aug 2007 23:17:23 -0500

> I am getting the following error message from drivers/base/core.c:
> 
> net eth1: device_rename: sysfs_create_symlink failed (-17)
> 
> Upon investigation, the call generating the error is renaming 'eth1' to 'eth1'. The following patch 
> suppresses the error.

I think this check belongs in udev not in the kernel.  Thankfully
this message at least tells us it is happening, please don't
remove it.

I'm pretty sure it's UDEV doing this, and it should not try to rename
a netdevice to what it already is named.

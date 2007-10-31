Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbXJaHBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbXJaHBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 03:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbXJaHBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 03:01:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45802
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752247AbXJaHBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 03:01:42 -0400
Date: Wed, 31 Oct 2007 00:01:41 -0700 (PDT)
Message-Id: <20071031.000141.241824894.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
Subject: Re: [PATCH]bluetooth: hci_sysfs connection bus_id add support for
 diffrent hci device
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071031023017.GA3896@darkstar.te-china.tietoenator.com>
References: <20071031023017.GA3896@darkstar.te-china.tietoenator.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>
Date: Wed, 31 Oct 2007 10:30:17 +0800

> diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
> --- linux/net/bluetooth/hci_sysfs.c	2007-10-31 10:21:00.000000000 +0800
> +++ linux.new/net/bluetooth/hci_sysfs.c	2007-10-31 10:21:55.000000000 +0800
> @@ -302,7 +302,8 @@ void hci_conn_add_sysfs(struct hci_conn 
>  	conn->dev.release = bt_release;
>  
>  	snprintf(conn->dev.bus_id, BUS_ID_SIZE,
> -			"%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
> +			"%s%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
> +			hdev->name,
>  			conn->type == ACL_LINK ? "acl" : "sco",
>  			ba->b[5], ba->b[4], ba->b[3],
>  			ba->b[2], ba->b[1], ba->b[0]);

This might not work.

Your device's name is already 15 characters long,
BUS_ID_SIZE is 20, and it seems hdev->name could
easily overflow the 4 or 5 characters of space
remaining.

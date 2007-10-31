Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbXJaH5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbXJaH5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 03:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbXJaH5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 03:57:08 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:34127 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbXJaH5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 03:57:08 -0400
Subject: Re: [PATCH]bluetooth: hci_sysfs connection bus_id add support for
	diffrent hci device
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <20071031.000141.241824894.davem@davemloft.net>
References: <20071031023017.GA3896@darkstar.te-china.tietoenator.com>
	 <20071031.000141.241824894.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 08:56:49 +0100
Message-Id: <1193817409.32459.10.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
> > --- linux/net/bluetooth/hci_sysfs.c	2007-10-31 10:21:00.000000000 +0800
> > +++ linux.new/net/bluetooth/hci_sysfs.c	2007-10-31 10:21:55.000000000 +0800
> > @@ -302,7 +302,8 @@ void hci_conn_add_sysfs(struct hci_conn 
> >  	conn->dev.release = bt_release;
> >  
> >  	snprintf(conn->dev.bus_id, BUS_ID_SIZE,
> > -			"%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
> > +			"%s%s%2.2X%2.2X%2.2X%2.2X%2.2X%2.2X",
> > +			hdev->name,
> >  			conn->type == ACL_LINK ? "acl" : "sco",
> >  			ba->b[5], ba->b[4], ba->b[3],
> >  			ba->b[2], ba->b[1], ba->b[0]);
> 
> This might not work.
> 
> Your device's name is already 15 characters long,
> BUS_ID_SIZE is 20, and it seems hdev->name could
> easily overflow the 4 or 5 characters of space
> remaining.

and should also be not needed since their parents are different. However
we had to add the connections to a bus. Otherwise the userspace will
never see them. I have to think about the right solution for this
problem.

Regards

Marcel



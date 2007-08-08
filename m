Return-Path: <linux-kernel-owner+w=401wt.eu-S932191AbXHHJdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbXHHJdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbXHHJdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:33:05 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:45529 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998AbXHHJdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:33:03 -0400
Date: Wed, 8 Aug 2007 11:33:59 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: Larry.Finger@lwfinger.net, linux-kernel@vger.kernel.org
Subject: Re: Error message from device_rename in drivers/base/core.c
Message-ID: <20070808113359.71e77f49@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070807.213724.27783161.davem@davemloft.net>
References: <46B943D3.9020207@lwfinger.net>
	<20070807.213724.27783161.davem@davemloft.net>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 21:37:24 -0700 (PDT),
David Miller <davem@davemloft.net> wrote:

> From: Larry Finger <Larry.Finger@lwfinger.net>
> Date: Tue, 07 Aug 2007 23:17:23 -0500
> 
> > I am getting the following error message from drivers/base/core.c:
> > 
> > net eth1: device_rename: sysfs_create_symlink failed (-17)
> > 
> > Upon investigation, the call generating the error is renaming 'eth1' to 'eth1'. The following patch 
> > suppresses the error.
> 
> I think this check belongs in udev not in the kernel.  Thankfully
> this message at least tells us it is happening, please don't
> remove it.

Hm, device_rename() could alternatively just return success if
dev->bus_id and new_name are the same.

> 
> I'm pretty sure it's UDEV doing this, and it should not try to rename
> a netdevice to what it already is named.

But it shouldn't cause an error either :)

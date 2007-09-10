Return-Path: <linux-kernel-owner+w=401wt.eu-S933400AbXIJLax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400AbXIJLax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 07:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbXIJLao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 07:30:44 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:9671 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbXIJLan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 07:30:43 -0400
Date: Mon, 10 Sep 2007 13:30:06 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [SYSFS - 2.6.23-rc5-git1 ] device_rename: sysfs_create_symlink
 failed (-17)
Message-ID: <20070910133006.26ddfdab@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46E15CB4.9040508@fr.ibm.com>
References: <46E15CB4.9040508@fr.ibm.com>
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

On Fri, 07 Sep 2007 16:14:12 +0200,
Daniel Lezcano <dlezcano@fr.ibm.com> wrote:

> Hi,
> 
> when using the 2.6.23-rc5-git1 kernel and trying to change a network 
> device name, I have the following error:
> 
> device_rename: sysfs_create_symlink failed (-17)

-EEXIST, maybe a double rename?

> 
> That comes from drivers/base/core.c : 1261

This is the link under the class directory to the renamed device.

> 
> I know anything about sysfs, so no much help to give... :(
> 
> I don't know if this is a bug, but my code use device_rename, check the 
> return value and fails. I will ignore it, but it seems not to be a 
> correct behavior to have such error.

Why does your code need to call device_rename() itself, I'd have
thought the networking code took care of it? (BTW: Which driver?)

> 
> Easy to reproduce:
> 	load a dummy network driver => dummy0
> 	change its name with : ip link set name foo0 dev dummy0

[Don't know if ip is sensitive to order, but shouldn't that be
ip link set dev dummy0 name foo0 ?]

You could try to switch on DEBUG_DRIVER and DEBUG_KOBJECT, this may
point to where the double name pops up. 

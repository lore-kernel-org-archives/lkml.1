Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYAIP6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYAIP6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYAIP6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:58:23 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:45656 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbYAIP6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:58:22 -0500
Date: Wed, 9 Jan 2008 16:57:48 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, kay.sievers@vrfy.org,
       Greg KH <greg@kroah.com>
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080109165748.419ad7fe@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <478490D2.5050902@gmail.com>
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu>
	<a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com>
	<20080102151642.GA7273@boogie.lpds.sztaki.hu>
	<20080105075039.GF27894@ZenIV.linux.org.uk>
	<20080107141300.GB12763@boogie.lpds.sztaki.hu>
	<47824415.80703@gmail.com>
	<20080107210024.GA13537@boogie.lpds.sztaki.hu>
	<47834593.1000506@gmail.com>
	<20080108133215.GA15814@boogie.lpds.sztaki.hu>
	<478490D2.5050902@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jan 2008 18:16:02 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> This isn't supported.  sysfs doesn't allow parents to die first and the
> dangling children to be salvaged using sysfs_move().

But (with the sysfs bugs fixed) it will return an error, won't it? It
seems the bluetooth code is rather optimistic with never checking
device_move()'s return code.

> 
> 2. Which in turn exposes three bugs in sysfs
> 	- sysfs_lookup() returning NULL on negative lookup.  sysfs
> 	  code requires that all negative dentries are shot down.
> 	  lookup should return -ENOENT instead of NULL.
> 	- in move and rename, error handling is wrong.  It ends up
> 	  passing ERR_PTR() values to dput().
> 	- there was an extra dput() in sysfs_move_dir().

Ups, seem to have copied that from some old version of
sysfs_rename_dir()...

> 
> The attached patch fixes all sysfs bugs and removes the oops. 

Looks OK at first glance.

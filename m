Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbXIYPeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbXIYPeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbXIYPeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:34:06 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:29494 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbXIYPeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:34:03 -0400
Date: Tue, 25 Sep 2007 17:32:54 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Pierre-Yves Paulus <py@idlum.be>
Cc: linux-kernel@vger.kernel.org,
       BlueZ development <bluez-devel@lists.sourceforge.net>
Subject: Re: Warnings and Oops on 2.6.23-rc6 while activily using rfcomm
 links (mm/slab.c)
Message-ID: <20070925173254.15c4e6bf@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46F92364.3080603@idlum.be>
References: <46F92364.3080603@idlum.be>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 17:04:04 +0200,
Pierre-Yves Paulus <py@idlum.be> wrote:

> Hello,
> 
> Putting the bluetooth system under load (opening and closing several 
> rfcomm links off several USB adapters, and transmitting data over them), 
> I got the Oops below. The computer hung completely, as you can see. Just 
> before, I also got those warnings.
> 
> I'm not sure if I'm providing the right and useful informations to allow 
> fixing of those problems, as I'm definitely no expert. Please tell me if 
> I do something the wrong way.
> 
> 
> WARNING: at lib/kref.c:33 kref_get()
>   [<c01c537b>] kref_get+0x34/0x3d
>   [<c01c484b>] kobject_get+0xf/0x13
>   [<c0223b2f>] get_device+0xe/0x14
>   [<c0223b48>] device_move+0x13/0xe2
>   [<d02f4b78>] rfcomm_tty_close+0x23/0x61 [rfcomm]
>   [<c020e0a4>] release_dev+0x1c0/0x54a
>   [<d02f40c9>] rfcomm_dev_destruct+0x59/0x65 [rfcomm]
>   [<d02f470c>] rfcomm_dev_ioctl+0x328/0x4e6 [rfcomm]
>   [<c012a3a8>] autoremove_wake_function+0x0/0x35
>   [<c02460bc>] release_sock+0xc/0x74
>   [<c0243f4e>] sock_ioctl+0x19f/0x1be
>   [<c020e435>] tty_release+0x7/0xa
>   [<c015be91>] __fput+0x93/0x147
>   [<c0159a39>] filp_close+0x51/0x58
>   [<c015aad1>] sys_close+0x54/0x83
>   [<c0103c72>] syscall_call+0x7/0xb
>   =======================

This looks like some refcounting is messed up...

> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_KOBJECT is not set

Switching these two on may provide helpful information.

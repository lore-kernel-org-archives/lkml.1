Return-Path: <linux-kernel-owner+w=401wt.eu-S1765314AbXJFUZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765314AbXJFUZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 16:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763972AbXJFUY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 16:24:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36485 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761393AbXJFUY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 16:24:56 -0400
Date: Sat, 6 Oct 2007 22:24:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Hugh Dickins <hugh@veritas.com>
cc: Guennadi Liakhovetski <lg@denx.de>, linux-kernel@vger.kernel.org
Subject: Re: tmpfs disabled in .config but in /proc/filesystems
In-Reply-To: <Pine.LNX.4.64.0710052136460.17084@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0710062221140.20637@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.60.0710051637200.10392@poirot.grange>
 <Pine.LNX.4.64.0710051637380.16909@blonde.wat.veritas.com>
 <Pine.LNX.4.60.0710052134180.10392@poirot.grange>
 <Pine.LNX.4.64.0710052136460.17084@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 5 2007 21:49, Hugh Dickins wrote:
>> > > $ zcat /proc/config.gz | grep TMPFS
>> > > # CONFIG_TMPFS is not set
>> > > $ grep tmpfs /proc/filesystems
>> > > nodev   tmpfs
>> > 
>> > tmpfs (mm/shmem.c) is used by the kernel to support shared memory
>> > of various kinds even when CONFIG_TMPFS is not set.  But only when
>> > CONFIG_TMPFS=y can users mount a tmpfs as a fully capable filesystem.
>> > Confusing, yes: sorry for putting the fear of craziness upon you.
>> 
>> Oops, sorry, now I remember reading about this... As a matter of fact, the 
>> presence in /proc/filesystem - was it a deliberate decision, or 
>> technically preferrable or a mistake?
>
>d) None of the above!
>
>I've never really thought about it, but I think it's simply a natural
>side-effect of the register_filesystem and vfs_kern_mount it has to
>do in order to get the services it needs from the VFS.

Well you could add a new flag to the file_system_type struct
("FS_INVISIBLE") that is set when this or that condition (like TMPFS=n)
is in effect. It would be just cosmetic though.

You can't mount a lot of other filesystems like the hidden bdev,
pipefs or sockfs (it would really be nice to explore them with ls!),
yet they are not invisible either right now.


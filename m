Return-Path: <linux-kernel-owner+w=401wt.eu-S1751416AbZEKFU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbZEKFU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 01:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZEKFUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 01:20:15 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:39545 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZEKFUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 01:20:15 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: Q. Switch open_exec() and sys_uselib() to do_open_filp() 
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090511040019.GI8633@ZenIV.linux.org.uk>
References: <29926.1242003317@jrobl> <20090511012828.GH8633@ZenIV.linux.org.uk> <31197.1242009975@jrobl> <20090511040019.GI8633@ZenIV.linux.org.uk>
Date: Mon, 11 May 2009 14:20:09 +0900
Message-ID: <7134.1242019209@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> Nope.  It ended up in nd->intent.open.flags due to path_lookup_open().

Yes.


> Then lookup_instantiate_filp() from a filesystem that might care about
> intents did
>         nd->intent.open.file = __dentry_open(dget(dentry), mntget(nd->mnt),
>                                              nd->intent.open.flags - 1,
>                                              nd->intent.open.file,
>                                              open);
> and nameidata_to_filp() ended up picking nd->intent.open.file.

FS supporting lookup_instantiate_filp() is rare, isn't it?
Simple grep told me it is called by fuse, nfsv4, cifs, and 9p only.
In other FS, FMODE_EXEC was dropped since nameidata_to_filp() (from
open_exec() directly) doesn't pick intent.open.flags up.

Anyway, I could confirm that setting FMODE_EXEC to f_flags is intended.
Thank you for your quick responces.


J. R. Okajima

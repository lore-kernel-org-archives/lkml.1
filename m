Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbYHUGr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbYHUGr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbYHUGrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:47:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54266
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757728AbYHUGrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:47:09 -0400
Date: Wed, 20 Aug 2008 23:47:08 -0700 (PDT)
Message-Id: <20080820.234708.193699562.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: greg@kroah.com, gregkh@suse.de, akpm@linux-foundation.org,
       htejun@gmail.com, dlezcano@fr.ibm.com, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk, containers@lists.osdl.org,
       benjamin.thery@bull.net, netdev@vger.kernel.org
Subject: Re: [PATCH 6/8] Revert "netns: Fix device renaming for sysfs"
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1vdxuzxco.fsf_-_@frodo.ebiederm.org>
References: <m18wuq27uj.fsf_-_@frodo.ebiederm.org>
	<m14p5e27tb.fsf_-_@frodo.ebiederm.org>
	<m1vdxuzxco.fsf_-_@frodo.ebiederm.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 20 Aug 2008 23:38:31 -0700

> 
> This reverts commit aaf8cdc34ddba08122f02217d9d684e2f9f5d575.
> 
> Drivers like the ipw2100 call device_create_group when they
> are initialized and device_remove_group when they are shutdown.
> Moving them between namespaces deletes their sysfs groups early.
> 
> In particular the following call chain results.
> netdev_unregister_kobject -> device_del -> kobject_del -> sysfs_remove_dir
> With sysfs_remove_dir recursively deleting all of it's subdirectories,
> and nothing adding them back.
> 
> Ouch!
> 
> Therefore we need to call something that ultimate calls sysfs_mv_dir
> as that sysfs function can move sysfs directories between namespaces
> without deleting their subdirectories or their contents.   Allowing
> us to avoid placing extra boiler plate into every driver that does
> something interesting with sysfs.
> 
> Currently the function that provides that capability is device_rename.
> That is the code works without nasty side effects as originally written.
> 
> So remove the misguided fix for moving devices between namespaces.  The
> bug in the kobject layer that inspired it has now been recognized and
> fixed.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: David S. Miller <davem@davemloft.net>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYASIwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYASIwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 03:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbYASIwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 03:52:10 -0500
Received: from mail.samba.org ([66.70.73.150]:44120 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbYASIwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 03:52:09 -0500
X-Greylist: delayed 1867 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jan 2008 03:52:09 EST
Subject: Re: [linux-cifs-client] [PATCH] Remove information leak in Linux
	CIFS client
From: simo <idra@samba.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: sfrench@samba.org, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, samba-technical@lists.samba.org
In-Reply-To: <20080119045552.GA11134@basil.nowhere.org>
References: <20080119045552.GA11134@basil.nowhere.org>
Content-Type: text/plain
Organization: Samba Team
Date: Sat, 19 Jan 2008 03:18:42 -0500
Message-Id: <1200730722.28706.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-19 at 05:55 +0100, Andi Kleen wrote:
> Fix information leak in CIFS client lookup
> 
> Putting arbitary file names on lookup failures into the system log is not
> a good idea, because usually everybody can read dmesg and that is thus
> an information leak if a directory was read protected.
> 
> Also changed the error printout for this case to a signed number, because
> it is normally negative and that makes it easier to read.
> 
> I'm not sure the message is all that useful anyways. Perhaps it 
> should be just removed completely? Or at least rate limited because
> it allows to spam the kernel log nicely.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> Index: linux/fs/cifs/dir.c
> ===================================================================
> --- linux.orig/fs/cifs/dir.c
> +++ linux/fs/cifs/dir.c
> @@ -518,7 +518,7 @@ cifs_lookup(struct inode *parent_dir_ino
>  	/*	if it was once a directory (but how can we tell?) we could do
>  		shrink_dcache_parent(direntry); */
>  	} else {
> -		cERROR(1, ("Error 0x%x on cifs_get_inode_info in lookup of %s",
> +		cERROR(1, ("Error %d on cifs_get_inode_info in lookup of file",
>  			   rc, full_path));

then please remove also full_path here ^^^^

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo@samba.org>
Senior Software Engineer at Red Hat Inc. <ssorce@redhat.com>


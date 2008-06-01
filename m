Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYFAQy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYFAQy4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYFAQys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:54:48 -0400
Received: from lazybastard.de ([212.112.238.170]:56049 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYFAQyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:54:47 -0400
Date: Sun, 1 Jun 2008 18:54:40 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: arnd@arndb.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 3/7] cramfs: allow unlinking of files
Message-ID: <20080601165439.GD13094@logfs.org>
References: <20080531152013.031903990@arndb.de> <20080531153510.820446949@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080531153510.820446949@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008 17:20:16 +0200, arnd@arndb.de wrote:
>  
> +int cramfs_unlink(struct inode *dir, struct dentry *dentry)
> +{
> +	struct inode *inode = dentry->d_inode;
> +	struct dentry *new;
> +
> +	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> +	drop_nlink(inode);
> +	new = d_alloc(dentry->d_parent, &dentry->d_name);
> +	d_add(new, NULL);
> +
> +	dget(dentry);

How is the negative dentry dropped on umount?  Looks like we want a
per-sb list to put them on.  Then we can walk it and dput each one at
umount time.

> +	return 0;
> +}

Jörn

-- 
"[One] doesn't need to know [...] how to cause a headache in order
to take an aspirin."
-- Scott Culp, Manager of the Microsoft Security Response Center, 2001

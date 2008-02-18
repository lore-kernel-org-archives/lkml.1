Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYBRQoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYBRQoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYBRQo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:44:28 -0500
Received: from ns2.suse.de ([195.135.220.15]:44895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYBRQo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:44:27 -0500
Date: Mon, 18 Feb 2008 17:44:25 +0100
From: Jan Blunck <jblunck@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mmotm] fs/sysfs/file.c d_path fix
Message-ID: <20080218164425.GC26915@hasse.suse.de>
References: <200802161912.m1GJC5Gt031939@agora.fsl.cs.sunysb.edu> <20080217130733.GA11483@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217130733.GA11483@infradead.org>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, Christoph Hellwig wrote:

> On Sat, Feb 16, 2008 at 02:12:05PM -0500, Erez Zadok wrote:
> > diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> > index 02223e2..a57b024 100644
> > --- a/fs/sysfs/file.c
> > +++ b/fs/sysfs/file.c
> > @@ -329,9 +329,11 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
> >  	struct sysfs_ops *ops;
> >  	int error = -EACCES;
> >  	char *p;
> > +	struct path sysfs_path;
> >  
> > -	p = d_path(file->f_dentry, sysfs_mount, last_sysfs_file,
> > -		   sizeof(last_sysfs_file));
> > +	sysfs_path.dentry = file->f_dentry;
> > +	sysfs_path.mnt = sysfs_mount;
> > +	p = d_path(&sysfs_path, last_sysfs_file, sizeof(last_sysfs_file));
> 
> A d_path(file->f_path, ..); should do it, but I'd really like to know
> what sysfs crowd was smoking when adding a d_path in ->open.  Guys,
> please explain what's going on here.
> 

This is from gregkh-driver-sysfs-crash-debugging.patch which is only in -mm I
guess.

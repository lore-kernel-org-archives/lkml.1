Return-Path: <linux-kernel-owner+w=401wt.eu-S1946123AbXDLKMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946123AbXDLKMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 06:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946121AbXDLKMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 06:12:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51037 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946116AbXDLKMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 06:12:38 -0400
Date: Thu, 12 Apr 2007 11:12:37 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Message-ID: <20070412101236.GD4095@ftp.linux.org.uk>
References: <20070412090809.917795000@suse.de> <20070412090836.207973000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412090836.207973000@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 02:08:10AM -0700, jjohansen@suse.de wrote:
> This is needed for computing pathnames in the AppArmor LSM.

Which is an argument against said LSM in current form.


> -	error = security_inode_create(dir, dentry, mode);
> +	error = security_inode_create(dir, dentry, nd ? nd->mnt : NULL, mode);

is a clear sign that interface is wrong.  Leaving aside the general
idiocy of "we prohibit to do something with file if mounted here,
but if there's another mountpoint, well, we just miss", an API of that
kind is just plain wrong.  Either you can live without seeing vfsmount
in that method (in which case you shouldn't pass it at all), or you
have a hole.

NACK.

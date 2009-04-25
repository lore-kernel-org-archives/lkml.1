Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbZDYDfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbZDYDfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 23:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZDYDfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 23:35:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37396 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbZDYDfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 23:35:07 -0400
Date: Sat, 25 Apr 2009 04:35:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch 04/27] fs: introduce mnt_clone_write
Message-ID: <20090425033503.GV8633@ZenIV.linux.org.uk>
References: <20090425012020.457460929@suse.de> <20090425012209.513109971@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425012209.513109971@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 11:20:24AM +1000, npiggin@suse.de wrote:
> This patch speeds up lmbench lat_mmap test by about another 2% after the
> first patch.
> 
> Before:
>  avg = 462.286
>  std = 5.46106
> 
> After:
>  avg = 453.12
>  std = 9.58257
> 
> (50 runs of each, stddev gives a reasonable confidence)
> 
> It does this by introducing mnt_clone_write, which avoids some heavyweight
> operations of mnt_want_write if called on a vfsmount which we know already
> has a write count; and mnt_want_write_file, which can call mnt_clone_write
> if the file is open for write.
> 
> After these two patches, mnt_want_write and mnt_drop_write go from 7% on
> the profile down to 1.3% (including mnt_clone_write).

NAK in this form; nested mnt_want_write() *CAN* fail (note the check for
superblock itself being r/o).  Make you mnt_clone_write() returning int
and doing that superblock check, and I'm OK with it.

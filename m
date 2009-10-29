Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZJ2TYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZJ2TYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbZJ2TYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:24:11 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46991 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474AbZJ2TYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:24:10 -0400
Date: Thu, 29 Oct 2009 13:24:14 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Tejun Heo <teheo@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/3] Sysfs: Allow directories to be populated dynamically
Message-ID: <20091029192414.GN10555@parisc-linux.org>
References: <20091020054740.GC29158@parisc-linux.org> <20091020055021.GE29158@parisc-linux.org> <4AE9C0B0.3030304@suse.de> <20091029162145.GM10555@parisc-linux.org> <4AE9C29E.6090706@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE9C29E.6090706@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 05:28:14PM +0100, Tejun Heo wrote:
>  struct sysfs_dirent {
> 	 atomic_t		s_count;
> 	 atomic_t		s_active;
> 	 struct sysfs_dirent	*s_parent;
> 	 struct sysfs_dirent	*s_sibling;
> 	 const char		*s_name;
> 
> 	 union {
> 		 struct sysfs_elem_dir		s_dir;
> 		 struct sysfs_elem_symlink	s_symlink;
> 		 struct sysfs_elem_attr		s_attr;
> 		 struct sysfs_elem_bin_attr	s_bin_attr;
> 	 };
> 
> 	 unsigned int		s_flags;
> 	 ino_t			s_ino;
> 	 umode_t			s_mode;
> 	 struct sysfs_inode_attrs *s_iattr;
> 	                          ^^

Oh, ouch.  That does change the calculus somewhat.

> It feels a bit too convoluted to me.  sysfs is already pretty
> convoluted and adding yet more convolution would require pretty good
> justification, so I'm curious about the numbers.

It is convoluted.  The advantage of this is that we get to create many
fewer dirents.  I wonder if we can do away with the dirents entirely, and
have dentries constructed dynamically instead.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbYBWM3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbYBWM3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYBWM3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:29:02 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36813 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYBWM3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:29:00 -0500
Date: Sat, 23 Feb 2008 12:28:59 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: Re: [RFC 02/11] introduce simple_fs_type
Message-ID: <20080223122859.GN27894@ZenIV.linux.org.uk>
References: <20080219040435.825494460@arndb.de> <20080219040828.690045213@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219040828.690045213@arndb.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 05:04:37AM +0100, Arnd Bergmann wrote:
> There is a number of pseudo file systems in the kernel
> that are basically copies of debugfs, all implementing the
> same boilerplate code, just with different bugs.
> 
> This adds yet another copy to the kernel in the libfs directory,
> with generalized helpers that can be used by any of them.
> 
> The most interesting function here is the new "struct dentry *
> simple_register_filesystem(struct simple_fs_type *type)", which
> returns the root directory of a new file system that can then
> be passed to simple_create_file() and similar functions as a
> parent.

Don't mix "split the file" with "add new stuff", please.  And frankly,
I'm not convinced that embedding file_system_type into another struct
is a good idea.

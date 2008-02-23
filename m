Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYBWMiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYBWMiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYBWMh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:37:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51874 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYBWMhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:37:54 -0500
Date: Sat, 23 Feb 2008 12:37:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: Re: [RFC 03/11] slim down debugfs
Message-ID: <20080223123753.GP27894@ZenIV.linux.org.uk>
References: <20080219040435.825494460@arndb.de> <20080219040828.823685054@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219040828.823685054@arndb.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 05:04:38AM +0100, Arnd Bergmann wrote:
> With most of debugfs now copied to generic code in libfs,
> we can remove the original copy and replace it with thin
> wrappers around libfs.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Index: linux-2.6/fs/Kconfig
> ===================================================================
> --- linux-2.6.orig/fs/Kconfig
> +++ linux-2.6/fs/Kconfig
> @@ -1001,6 +1001,14 @@ config CONFIGFS_FS
>  	  Both sysfs and configfs can and should exist together on the
>  	  same system. One is not a replacement for the other.
>  
> +config LIBFS
> +	tristate
> +	default m
> +	help
> +	  libfs is a helper library used by many of the simpler file
> +	  systems. Parts of libfs can be modular when all of its users
> +	  are modules as well, and the users should select this symbol.

NAK.  For one thing, you need dependencies or selects and none of the
patches later in the series introduces them.  For another, neither
dependencies nor selects work well if you have non-modular users of
that sucker.  Seriously, try to add those and do allmodconfig.  Then
look what a mess it produces.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYKLQxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYKLQxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYKLQx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:53:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33792 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYKLQx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:53:28 -0500
Date: Wed, 12 Nov 2008 11:53:25 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Subject: Re: [PATCH =-v3 11/21] fanotify: give a special access permission
	check
Message-ID: <20081112165325.GC19669@infradead.org>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com> <20081112161124.25434.86250.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112161124.25434.86250.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 11:11:24AM -0500, Eric Paris wrote:
>  	fsnotify_open_exec(file);
> +	error = fanotify(file, FAN_ACCESS_EXEC_PERM);
> +	if (error) {
> +		fput(file);
> +		goto out;
> +	}

Adding your own fanotify calls next to the fsnotify calls completely
defeats th purpose of these.  Please make sure we have one set of hooks.
And given that we now have three notification schemes I think it's
getting time that you also unifify the actuall backends (buffering, etc)
instead of faning out at the fsnotify layer and just leave dnotify and
inotify as tiny userspace interface layers.


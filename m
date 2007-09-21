Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbXIUNOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbXIUNOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbXIUNOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:14:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58844 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbXIUNOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:14:10 -0400
Date: Fri, 21 Sep 2007 14:14:09 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 5/5] VFS: allow filesystem to override mknod capability checks
Message-ID: <20070921131409.GA9988@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070921122343.307289079@szeredi.hu> <20070921123336.095183254@szeredi.hu> <20070921124504.GC8088@infradead.org> <E1IYiH4-0001eQ-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IYiH4-0001eQ-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 03:10:26PM +0200, Miklos Szeredi wrote:
> Take this example: I've loopback mounted an UML disk image using fuse
> (no privileges required), and want to create some device nodes.  I
> can't yet boot the UML because the device node is missing from the
> image.  So what should I do.  Currently I have to manipulate the
> mounted image as root.  But that's really shouldn't be needed.

That's something that shouldn't be solved in the filesystem, but rather
through exact semantics of unprivilegued mounts.  Given that an
unprivilegued implies ignoring the device files we can easily allow
users to create them, because they're nothing special anymore.


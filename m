Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbXIUOzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbXIUOzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761569AbXIUOyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:54:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54887 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760752AbXIUOx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:53:57 -0400
Date: Fri, 21 Sep 2007 15:53:56 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 5/5] VFS: allow filesystem to override mknod capability checks
Message-ID: <20070921145356.GA16379@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070921122343.307289079@szeredi.hu> <20070921123336.095183254@szeredi.hu> <20070921124504.GC8088@infradead.org> <E1IYiH4-0001eQ-00@dorka.pomaz.szeredi.hu> <20070921131409.GA9988@infradead.org> <E1IYiOv-0001f6-00@dorka.pomaz.szeredi.hu> <20070921143338.GA14577@infradead.org> <E1IYjoQ-0001kT-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IYjoQ-0001kT-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 04:48:58PM +0200, Miklos Szeredi wrote:
> Ah, OK.  Well, that's what fuse would do with the above change.  So
> you are basically saying, the change is OK, but we want proper
> unprivileged mounts first.

Yes, that and that it should be a mount flag, not a file_system_type
flag.

> I'm sure we don't want it by default.
> 
> For example if user bind mounts / onto /home/user/myroot (with 'nodev'
> of couse), we still don't want mknod to work on that mount, for
> obvious reasons.

True, we'll have to deny it if there is any non-privilegued mount of
the backing device possible.   At this point it's getting rather nasty
and I wonder whether it's really worth it..

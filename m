Return-Path: <linux-kernel-owner+w=401wt.eu-S1761039AbZLJQeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761039AbZLJQeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:34:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760981AbZLJQeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:34:01 -0500
Received: from cantor.suse.de ([195.135.220.2]:49278 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760801AbZLJQeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:34:00 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] fsnotify/vfsmount: add fsnotify fields to struct vfsmount
Date: Thu, 10 Dec 2009 17:31:42 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; i686; ; )
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20091203055315.21918.83562.stgit@paris.rdu.redhat.com> <20091204153925.GA17062@infradead.org>
In-Reply-To: <20091204153925.GA17062@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912101731.43050.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 December 2009 16:39:25 Christoph Hellwig wrote:
> What's the rationale for adding them?

The idea is to provide a mechanism to watch for "all events", but in a 
namespace aware way: for that, a process registers interest in all mount 
points it can reach.  With the previous hack, a global "I want it all" flag, 
per-namespace listeners were not possible.

Root can use bind mounts onto themselves (e.g., mount --bind /foo/bar 
/foo/bar) to watch arbitrary directories with the per-mount-point mechanism.  
Mount as user will open up additional use cases.

It would be nice to be able to register interest in all events below a 
directory which is not a mount point, too.  The problem with that is that the 
number of cached inodes below a given directory could be huge -- and we would 
have to visit them all atomically in order to "mark" them, which is not 
feasible.  The per-mount-point mechanism will eventually give us *almost* the 
same, and so I believe it's good enough.

Thanks,
Andreas

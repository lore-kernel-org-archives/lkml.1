Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbZF3DH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbZF3DH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 23:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZF3DHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 23:07:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:57482 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbZF3DHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 23:07:17 -0400
Message-ID: <4A498115.4080006@kernel.org>
Date: Tue, 30 Jun 2009 12:05:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Subject: Re: [PATCH 1/4] fdtable: export alloc_fd()
References: <1245317073-24000-1-git-send-email-tj@kernel.org> <1245317073-24000-2-git-send-email-tj@kernel.org> <20090624043926.GN8633@ZenIV.linux.org.uk>
In-Reply-To: <20090624043926.GN8633@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 03:06:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Al.

Al Viro wrote:
> On Thu, Jun 18, 2009 at 06:24:30PM +0900, Tejun Heo wrote:
>> Export alloc_fd().  Will be used by FUSE.
> 
> Where and how?

This currently is used via get_unused_fd_flags() in
fuse_mmap_commit_prep().  A shmem_file is created in the requesting
client's context (for accounting and easier flow of control) and then
passed to the server's context where an fd is allocated and assigned
to the file so that the fd can be passed to the userland server.

The shmem_file based implementation serves certain device mmap file
emulation well but as Miklos pointed out it may not be sufficiently
flexible for other purposes and passing file back and forth and
wrapping shmem_file is quite ugly, so I think there's pretty good
chance it will get reimplemented in some different way which likely
won't need alloc_fd() exported.  If there's any vfs related changes,
I'll cc you.

Thanks.

-- 
tejun

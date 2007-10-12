Return-Path: <linux-kernel-owner+w=401wt.eu-S1761166AbXJLQda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761166AbXJLQda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760675AbXJLQKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:10:41 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38141 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760031AbXJLQKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:10:38 -0400
Subject: Re: [patch 2/2] r/o bind mounts: Accept passing a mnt NULL pointer
	to mnt_drop_write()
From: Dave Hansen <haveblue@us.ibm.com>
To: Jan Blunck <jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20071012155020.197228145@hasse.suse.de>
References: <20071012155019.747515889@hasse.suse.de>
	 <20071012155020.197228145@hasse.suse.de>
Content-Type: text/plain
Date: Fri, 12 Oct 2007 09:10:11 -0700
Message-Id: <1192205411.20859.52.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-12 at 17:50 +0200, Jan Blunck wrote:
> In case of somebody opens a file with dentry_open(dentry, NULL, ...) we don't
> want to stumble on the NULL pointer mnt in struct file. 
...
> +++ b/fs/namespace.c
> @@ -253,6 +253,9 @@ void mnt_drop_write(struct vfsmount *mnt
>         int must_check_underflow = 0;
>         struct mnt_writer *cpu_writer;
> 
> +       if (!mnt)
> +               return;

I kinda wish we'd fix these in the callers.  I know we do something
similar to this with mntput(), but I worry a bit that this just
discourages people from using the right interfaces.

Do you have a case where we're actually getting a NULL mount in here?
We had at least one in reiser4 that really revealed some nastiness in
the fs that needed fixing.

-- Dave


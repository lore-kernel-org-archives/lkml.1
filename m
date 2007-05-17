Return-Path: <linux-kernel-owner+w=401wt.eu-S1760462AbXEQHW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462AbXEQHW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 03:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXEQHWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 03:22:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36984 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbXEQHWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 03:22:49 -0400
Date: Thu, 17 May 2007 08:22:47 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Convert namespace_sem to a mutex
Message-ID: <20070517072247.GQ4095@ftp.linux.org.uk>
References: <20070517045041.GA4462@in.ibm.com> <20070517050046.GM4095@ftp.linux.org.uk> <20070517071720.GC4462@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517071720.GC4462@in.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 12:47:20PM +0530, Bharata B Rao wrote:
> Ok, I wasn't aware that this rwsem had many concurrent readers. From whatever
> little I could see (during system boot and during kernel compilation with
> make -j), the number of concurrent readers very rarely touched 3 and was 1
> mostly. May be there are other concurrent readers of this sem. Any idea
> from where they could be coming from ?

Anybody reading from /proc/mounts?  You do realize that on systems where
/etc/mtab is a symlink to /proc/mounts every df(1), etc. - anything that
wants to find out all mountpoints - will read through that file?

The whole point is that we need exclusion between those who modify
mount tree *and* between them and anyone who looks at the mount tree.
We don't need any exclusion between several processes that happen to
examine the current mount tree at the same time.  And since those
are far more frequent than those who modify the tree...

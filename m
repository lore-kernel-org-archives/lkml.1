Return-Path: <linux-kernel-owner+w=401wt.eu-S967807AbXG3SXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967807AbXG3SXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966735AbXG3SXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:23:32 -0400
Received: from [212.12.190.96] ([212.12.190.96]:33779 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S966466AbXG3SXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:23:30 -0400
From: Al Boldi <a1426z@gawab.com>
To: Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC 00/26] VFS based Union Mount (V2)
Date: Mon, 30 Jul 2007 21:23:24 +0300
User-Agent: KMail/1.5
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20070730161323.100048969@weierstrass.suse.de>
In-Reply-To: <20070730161323.100048969@weierstrass.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707302123.24542.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Blunck wrote:
> Here is another post of the VFS based union mount implementation. Unlike
> the traditional mount which hides the contents of the mount point, union
> mounts present the merged view of the mount point and the mounted
> filesytem.

Great!

> Recent changes:
> - brand new union structure no longer tied to the dentryn, now works with
> bind mounts
> - generic part of the whiteout patches extracted
> - introduces MS_WHITEOUT to make the white-out patches independant of the
>   union-mount stuff
> - uses a singleton whiteout inode for the tmpfs filesystem (I need to fix
> this for ext2/3, too)
> - renaming files on unions uses copyup now

I wonder if this copyup functionality could be generalized to induce CoW when 
modifying hard-linked files.  Does that sound feasible?

> - rewrote the union mount debugging code: it is now debugfs/relay based.
> - random cleanups
>
> I'm able to compile the kernel with this patches applied on a  3 layer
> union mount with the seperate layers bind mounted to different locations.
> I haven't done any performance tests since I think there is a more
> important topic ahead: better readdir() support.

What about the umount oops?  Did that get fixed?

> This series is against 2.6.22-rc6-mm1.

Things as big and important like this should probably also be diff'd against 
mainline, to increase testing input.


Thanks!

--
Al


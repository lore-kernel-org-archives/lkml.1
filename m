Return-Path: <linux-kernel-owner+w=401wt.eu-S933305AbXDFXCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbXDFXCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933313AbXDFXCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:02:45 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36795 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933305AbXDFXCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:02:44 -0400
Date: Fri, 6 Apr 2007 16:02:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] unprivileged mount syscall
Message-Id: <20070406160238.f3178189.akpm@linux-foundation.org>
In-Reply-To: <20070404183012.429274832@szeredi.hu>
References: <20070404183012.429274832@szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 20:30:12 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> This patchset adds support for keeping mount ownership information in
> the kernel, and allow unprivileged mount(2) and umount(2) in certain
> cases.

No replies, huh?

My knowledge of the code which you're touching is not strong, and my spare
reviewing capacity is not high.  And this work does need close review by
people who are familar with the code which you're changing.

So could I suggest that you go for a dig through the git history, identify
some individuals who look like they know this code, then do a resend,
cc'ing those people?  Please also cc linux-kernel on that resend.

> This can be useful for the following reasons:
> 
> - mount(8) can store ownership ("user=XY" option) in the kernel
>   instead, or in addition to storing it in /etc/mtab.  For example if
>   private namespaces are used with mount propagations /etc/mtab
>   becomes unworkable, but using /proc/mounts works fine
> 
> - fuse won't need a special suid-root mount/umount utility.  Plain
>   umount(8) can easily be made to work with unprivileged fuse mounts
> 
> - users can use bind mounts without having to pre-configure them in
>   /etc/fstab
> 
> All this is done in a secure way, and unprivileged bind and fuse
> mounts are disabled by default and can be enabled through sysctl or
> /proc/sys.
> 
> One thing that is missing from this series is the ability to restrict
> user mounts to private namespaces.  The reason is that private
> namespaces have still not gained the momentum and support needed for
> painless user experience.  So such a feature would not yet get enough
> attention and testing.  However adding such an optional restriction
> can be done with minimal changes in the future, once private
> namespaces have matured.

I suspect the people who developed and maintain nsproxy would disagree ;)

Please also cc containers@lists.osdl.org.

> An earlier version of these patches have been discussed here:
> 
>   http://lkml.org/lkml/2005/5/3/64
> 
> --

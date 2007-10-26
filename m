Return-Path: <linux-kernel-owner+w=401wt.eu-S1764339AbXJZUds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764339AbXJZUds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXJZUdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:33:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35856 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbXJZUdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:33:39 -0400
Date: Fri, 26 Oct 2007 21:33:37 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: John Johansen <jjohansen@suse.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 19/45] Add struct vfsmount parameters to vfs_rename()
Message-ID: <20071026203337.GF8181@ftp.linux.org.uk>
References: <20071026064024.243943043@suse.de> <20071026064049.534093497@suse.de> <20071026073749.GE8181@ftp.linux.org.uk> <20071026182352.GA32415@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026182352.GA32415@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 11:23:53AM -0700, John Johansen wrote:

> In the current code, both vfsmounts are always identical, and so one of
> the two should go, agreed.
> 
> The thought behind passing both vfsmounts was that they could differ but
> point to the same super_block, in which case renames would still be
> possible at least from a filesystem point of view. The essential
> restriction here is that both files must be on the same device; the vfs
> restriction of not allowing cross-mount renames is arbitrary.

It's called "access control".  Pathname-based one, BTW.  And yes, it's
100% deliberate.

> Cross-mount renames are not allowed currently, and granted, they may not
> be very useful, either.

<raised brows>
Excuse me, but IIRC LSM was supposed to _add_ restrictions, not to remove
existing security checks.

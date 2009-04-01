Return-Path: <linux-kernel-owner+w=401wt.eu-S1762835AbZDAMNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835AbZDAMNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757195AbZDAMNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:13:30 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:32851 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756577AbZDAMN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:13:29 -0400
Subject: Re: [PATCH] Free the temporary vfsmount created in
	bdev_cache_init()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Cheng Renquan <crquan@gmail.com>
In-Reply-To: <20090401114955.GC28946@ZenIV.linux.org.uk>
References: <20090401110703.12974.99902.stgit@pc1117.cambridge.arm.com>
	 <20090401114955.GC28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 01 Apr 2009 13:12:08 +0100
Message-Id: <1238587928.14550.16.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2009 12:12:41.0840 (UTC) FILETIME=[28212F00:01C9B2C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 12:49 +0100, Al Viro wrote:
> On Wed, Apr 01, 2009 at 12:07:37PM +0100, Catalin Marinas wrote:
> > The vfsmount structure allocated in this function (the bd_mnt local
> > variable) is only used to obtain the blockdev_superblock and there are
> > no other references to it. This structure can be safely freed (and
> > prevent kmemleak from reporting it).
> 
> NAK.  This kind of kludges is simply not worth doing.  Store the
> pointer to vfsmount into a static-in-file variable if you want
> to get kmemleak to STFU.

That's how it used to be until commit c2acf7b9 made bd_mnt a local
variable. Rather than reverting part of this commit, I can add a
kmemleak_ignore() call to shut it up.

-- 
Catalin


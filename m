Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbXDBH2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbXDBH2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbXDBH2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:28:33 -0400
Received: from mx1.suse.de ([195.135.220.2]:35565 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbXDBH2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:28:33 -0400
Date: Mon, 2 Apr 2007 00:28:58 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: driver core: do not wait unnecessarily in driver_unregister()
Message-ID: <20070402072858.GA19241@kroah.com>
References: <200704012059.l31Kx2R5005810@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704012059.l31Kx2R5005810@hera.kernel.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2007 at 08:59:02PM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f5ef2abcbeb5b0be23f7cc610a024b2406e3d8e6
> Commit:     f5ef2abcbeb5b0be23f7cc610a024b2406e3d8e6
> Parent:     755948cfca16c71b16e8ff4a9d4dd31b1c0bf923
> Author:     Linus Torvalds <torvalds@woody.linux-foundation.org>
> AuthorDate: Sun Apr 1 10:54:13 2007 -0700
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Sun Apr 1 10:54:13 2007 -0700
> 
>     driver core: do not wait unnecessarily in driver_unregister()
>     
>     Ingo reported that built-in drivers suffered bootup hangs with certain
>     driver unregistry sequences, due to sysfs breakage.
>     
>     Do the minimal fix for v2.6.21: only wait if the driver is a module.
>     
>     Acked-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Linus, please revert this patch.  It merely papers over the fact that
there is a reference count still around that never gets released.  Kay's
patch that Andrew just forwarded to you fixes the real problem, which
other people had noticed and this patch does not fix.

thanks,

greg k-h

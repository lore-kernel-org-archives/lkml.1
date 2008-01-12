Return-Path: <linux-kernel-owner+w=401wt.eu-S1763523AbYALBFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763523AbYALBFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 20:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762843AbYALBFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 20:05:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49963 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763442AbYALBFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 20:05:35 -0500
Date: Fri, 11 Jan 2008 17:05:28 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1 (driver core/sysfs)
Message-ID: <20080112010528.GA1590@kroah.com>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071231121115.b7ae39e4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231121115.b7ae39e4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 12:11:15PM -0800, Randy Dunlap wrote:
> On Sat, 22 Dec 2007 23:30:56 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/
> 
> 
> With CONFIG_BLOCK=n:
> 
>   LD      drivers/block/built-in.o
> /local/linsrc/linux-2.6.24-rc6-mm1/drivers/base/core.c: In function 'device_add_class_symlinks':
> /local/linsrc/linux-2.6.24-rc6-mm1/drivers/base/core.c:707: error: 'part_type' undeclared (first use in this function)
> /local/linsrc/linux-2.6.24-rc6-mm1/drivers/base/core.c: In function 'device_remove_class_symlinks':
> /local/linsrc/linux-2.6.24-rc6-mm1/drivers/base/core.c:746: error: 'part_type' undeclared (first use in this function)
> make[3]: *** [drivers/base/core.o] Error 1
> 
> 
> and that is after fixing (in some sense) the first CONFIG_BLOCK=n
> problem with the patch below.  Please test lots of configs.
> and/or use 'make randconfig' (automated, scripted, e.g., etc.).
> maybe check Documentation/SubmitChecklist.  :)

Ingo seems to be saying that he has some kind of "automated" build
system to do this kind of checking.  Ingo, did you ever post how you did
this anywhere?  I have enough spare machines here that I should be able
to set up something to test my stuff this way easier than doing it by
hand all the time (as the above problem proves I do miss things :(  )

> ---
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Parts of driver core use blk_lookup_devt() when CONFIG_BLOCK=n,
> so provide an short inline version of it for that case.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks for this patch, I've merged it with the original block patch so
there is no regression along the way.

greg k-h

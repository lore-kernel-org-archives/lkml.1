Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbXJEPY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbXJEPY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbXJEPYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:24:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:37463 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471AbXJEPYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:24:51 -0400
Date: Fri, 5 Oct 2007 08:22:28 -0700
From: Greg KH <gregkh@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: wfg@mail.ustc.edu.cn, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: BUG on unloading the fuse module
Message-ID: <20071005152228.GB18797@suse.de>
References: <391574553.18064@ustc.edu.cn> <E1Idjd8-0002rY-00@dorka.pomaz.szeredi.hu> <391581094.26735@ustc.edu.cn> <E1Idkor-0002v6-00@dorka.pomaz.szeredi.hu> <391582087.27602@ustc.edu.cn> <E1IdlQc-0002wt-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IdlQc-0002wt-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 01:33:10PM +0200, Miklos Szeredi wrote:
> > > > > > In 2.6.23-rc8-mm2, the fuse module always bugs on unloading.
> > > > > 
> > > > > It's fixed in Greg's patch queue.
> > > > > 
> > > > > This patch against -mm will also fix it.
> > > > 
> > > > Oh no, it panics:
> > > 
> > > How about this one?
> > 
> > Yes, it did the trick.
> 
> Thanks.
> 
> It seems, some kobject ->release() function is freeing kobj->k_name,
> so we need to free it, and set it to NULL _before_ calling
> ->release().
> 
> Greg, can you please fix that in your queue?

It is already be fixed that way, but I think that Andrew didn't pull
from my updated queue for that release for a number of other reasons.

thanks,

greg k-h

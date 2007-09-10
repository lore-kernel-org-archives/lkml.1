Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbXIJV7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbXIJV7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 17:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761004AbXIJV7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 17:59:23 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:50818 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760997AbXIJV7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 17:59:23 -0400
Date: Mon, 10 Sep 2007 23:59:27 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] mm/memcontrol.c: clenups
Message-ID: <20070910215927.GI3563@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070909202548.GW3563@stusta.de> <46E4FEF7.1090308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46E4FEF7.1090308@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 01:53:19PM +0530, Balbir Singh wrote:
> Adrian Bunk wrote:
> > On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
> >> ...
> >> Changes since 2.6.23-rc3-mm1:
> >> ...
> >> +memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
> >> ...
> >>  memory containment
> >> ...
> > 
> > This patch makes the following needlessly global functions static:
> > - lock_page_container()
> > - unlock_page_container()
> > - __mem_container_move_lists()
> > 
> > Additionally, there was no reason for the "mem_control_type" object.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > ---
> > 
> >  mm/memcontrol.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > b582cc510b6b0a182dc56025828e7a3c566b9724 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 8162d98..49bf04f 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -91,7 +91,7 @@ enum {
> >  	MEM_CONTAINER_TYPE_CACHED,
> >  	MEM_CONTAINER_TYPE_ALL,
> >  	MEM_CONTAINER_TYPE_MAX,
> > -} mem_control_type;
> > +};
> > 
> 
> Not sure about this, is this the preferred style?
>...


It's not about style - your "mem_control_type" was not an identifier,
it was an (unused) variable.


It seems the intended code was:

enum mem_control_type {
        MEM_CONTAINER_TYPE_UNSPEC = 0,
        MEM_CONTAINER_TYPE_MAPPED,
        MEM_CONTAINER_TYPE_CACHED,
        MEM_CONTAINER_TYPE_ALL,
        MEM_CONTAINER_TYPE_MAX,
};


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


Return-Path: <linux-kernel-owner+w=401wt.eu-S1422770AbXBUSYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422770AbXBUSYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422769AbXBUSYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:24:31 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:55098 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422766AbXBUSYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:24:30 -0500
To: staubach@redhat.com
CC: akpm@linux-foundation.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-reply-to: <45DC8A47.5050900@redhat.com> (message from Peter Staubach on
	Wed, 21 Feb 2007 13:07:03 -0500)
Subject: Re: [PATCH] update ctime and mtime for mmaped write
References: <E1HJvdA-0003Nj-00@dorka.pomaz.szeredi.hu> <45DC8A47.5050900@redhat.com>
Message-Id: <E1HJw7l-0003Tq-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 21 Feb 2007 19:23:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Inspired by Peter Staubach's patch and the resulting comments.
> >
> >   
> 
> An updated version of the original patch was submitted to LKML
> yesterday...  :-)

Strange coincidence :)

> >  		file = vma->vm_file;
> >  		start = vma->vm_end;
> > +		mapping_update_time(file);
> >  		if ((flags & MS_SYNC) && file &&
> >  				(vma->vm_flags & VM_SHARED)) {
> >  			get_file(file);
> >   
> 
> It seems to me that this might lead to file times being updated for
> non-MAP_SHARED mappings.

In theory no, because the COW-ed pages become anonymous and are not
part of the original mapping any more.

> > +int set_page_dirty_mapping(struct page *page);
> >   
> 
> This aspect of the design seems intrusive to me.  I didn't see a strong
> reason to introduce new versions of many of the routines just to handle
> these semantics.  What motivated this part of your design?  Why the new
> _mapping versions of routines?

Because there's no way to know inside the set_page_dirty() functions
if the dirtying comes from a memory mapping or from a modification
through a normal write().  And they have different semantics, for
write() the modification times are updated immediately.

Thanks,
Miklos

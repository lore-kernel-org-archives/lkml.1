Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbXITXg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbXITXg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 19:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXITXgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 19:36:21 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39846 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbXITXgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 19:36:20 -0400
Date: Thu, 20 Sep 2007 19:35:57 -0400
Message-Id: <200709202335.l8KNZv4v021925@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/11] eCryptfs: Replace encrypt, decrypt, and inode size write 
In-reply-to: Your message of "Thu, 20 Sep 2007 16:44:47 CDT."
             <20070920214447.GB8496@halcrow.austin.ibm.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20070920214447.GB8496@halcrow.austin.ibm.com>, Michael Halcrow writes:
> On Wed, Sep 19, 2007 at 10:46:26PM -0700, Andrew Morton wrote:
> (from ecryptfs_encrypt_page()):
> > > +	enc_extent_virt = kmalloc(PAGE_CACHE_SIZE, GFP_USER);
> > 
> > I'd have thought that alloc_page() would be nicer.  After all, we _are_
> > treating it as a page, and not as a random piece of memry.
> >
> > > +	if (!enc_extent_virt) {
> > > +		rc = -ENOMEM;
> > > +		ecryptfs_printk(KERN_ERR, "Error allocating memory for "
> > > +				"encrypted extent\n");
> > > +		goto out;
> > > +	}
> > > +	enc_extent_page = virt_to_page(enc_extent_virt);
> > 
> > And then we don't need this.
> 
> If neither kmap() nor kmap_atomic() can be safely used to get a
> virtual address to pass to vfs_write(), then I do not know what my
> other options are here.

kmap_atomic is intended for short-lived code sections, where you may not
sleep, so you can't do a vfs_read/write in b/t kmap/kunmap_atomic.

Erez.

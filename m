Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbXITVpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbXITVpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbXITVox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:44:53 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33823 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbXITVov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:44:51 -0400
Date: Thu, 20 Sep 2007 16:44:47 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/11] eCryptfs: Replace encrypt, decrypt, and inode size write
Message-ID: <20070920214447.GB8496@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com> <20070917214710.GL13679@halcrow.austin.ibm.com> <20070919224626.f73f3f77.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919224626.f73f3f77.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 10:46:26PM -0700, Andrew Morton wrote:
(from ecryptfs_encrypt_page()):
> > +	enc_extent_virt = kmalloc(PAGE_CACHE_SIZE, GFP_USER);
> 
> I'd have thought that alloc_page() would be nicer.  After all, we _are_
> treating it as a page, and not as a random piece of memry.
>
> > +	if (!enc_extent_virt) {
> > +		rc = -ENOMEM;
> > +		ecryptfs_printk(KERN_ERR, "Error allocating memory for "
> > +				"encrypted extent\n");
> > +		goto out;
> > +	}
> > +	enc_extent_page = virt_to_page(enc_extent_virt);
> 
> And then we don't need this.

If neither kmap() nor kmap_atomic() can be safely used to get a
virtual address to pass to vfs_write(), then I do not know what my
other options are here.

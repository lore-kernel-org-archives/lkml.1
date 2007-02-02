Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXBBLPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXBBLPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 06:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbXBBLPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 06:15:13 -0500
Received: from ppsw-3.csi.cam.ac.uk ([131.111.8.133]:46054 "EHLO
	ppsw-3.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXBBLPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 06:15:12 -0500
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] NTFS: Rename apparently incorrect macro name
	"NTFS_DEBUG".
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, aia21@cantab.net
In-Reply-To: <1170414630.5749.0.camel@imp.csi.cam.ac.uk>
References: <Pine.LNX.4.64.0702020543230.16913@CPE00045a9c397f-CM001225dbafb6>
	 <1170414630.5749.0.camel@imp.csi.cam.ac.uk>
Content-Type: text/plain
Organization: Computing Service, University of Cambridge, UK
Date: Fri, 02 Feb 2007 11:14:04 +0000
Message-Id: <1170414844.5749.2.camel@imp.csi.cam.ac.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to say the most important bit:  Thanks for the catch!  (-:

Best regards,

	Anton

On Fri, 2007-02-02 at 11:10 +0000, Anton Altaparmakov wrote:
> Hi,
> 
> On Fri, 2007-02-02 at 05:46 -0500, Robert P. J. Day wrote:
> >   Replace the apparently incorrect macro name "NTFS_DEBUG" with
> > "CONFIG_NTFS_DEBUG".
> > 
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> > 
> > ---
> > 
> > diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
> > index c577d8e..2154d03 100644
> > --- a/fs/ntfs/attrib.c
> > +++ b/fs/ntfs/attrib.c
> > @@ -1921,7 +1921,7 @@ s64 ntfs_attr_extend_allocation(ntfs_inode *ni, s64 new_alloc_size,
> >  	u32 attr_len = 0; /* Silence stupid gcc warning. */
> >  	bool mp_rebuilt;
> > 
> > -#ifdef NTFS_DEBUG
> > +#ifdef CONFIG_NTFS_DEBUG
> 
> The fix is also wrong.  It should be:
> 
> #ifdef DEBUG
> 
> See fs/ntfs/Makefile for details...
> 
> >  	read_lock_irqsave(&ni->size_lock, flags);
> >  	allocated_size = ni->allocated_size;
> >  	read_unlock_irqrestore(&ni->size_lock, flags);
> 
> Best regards,
> 
>         Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


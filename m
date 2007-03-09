Return-Path: <linux-kernel-owner+w=401wt.eu-S1767378AbXCIQlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767378AbXCIQlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767386AbXCIQlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:41:09 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57852 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767384AbXCIQlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:41:07 -0500
Date: Fri, 9 Mar 2007 11:34:15 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Re: [PATCH 1/2] eCryptfs: convert lookup_one_len() to lookup_one_len_nd()
Message-ID: <20070309163415.GA21427@filer.fsl.cs.sunysb.edu>
References: <11717026161843-git-send-email-jsipek@cs.sunysb.edu> <11717026163831-git-send-email-jsipek@cs.sunysb.edu> <20070309094000.GA28599@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309094000.GA28599@infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 09:40:00AM +0000, Christoph Hellwig wrote:
> On Sat, Feb 17, 2007 at 03:56:55AM -0500, Josef 'Jeff' Sipek wrote:
> > From: Michael Halcrow <mhalcrow@us.ibm.com>
> > 
> > Call the new lookup_one_len_nd() rather than lookup_one_len().  This fixes an
> > oops when stacked on NFS.
> > 
> > Note that there are still some issues with eCryptfs on NFS having to do with
> > directory deletion (I'm not getting an oops, just an -EBUSY).
> 
> Biug NACK here.  This is just working around the broken lookup intents
> code.  lookup_one_len still is a hack for some network filesystems that
> unfortunately grew a few too many users.
 
I'm working on the 4-th case to do_path_lookup. The only problem left, is
the negative dentries. do_path_lookup returns -ENOENT. Which would means
that we need either a wrapper that returns the negative dentry instead of 
 
> Implementing this might be a good idea anyway to clean up the mess
> do_path_lookup is currently.

Clean up? There are 4 (including the new case) "setup" cases, and then the
actual lookup happens. You'll need the crazy if conditions unless the mening
of the arguments changes.

Josef "Jeff" Sipek.

-- 
UNIX is user-friendly ... it's just selective about who it's friends are

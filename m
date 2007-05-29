Return-Path: <linux-kernel-owner+w=401wt.eu-S1761692AbXE2DBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761692AbXE2DBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 23:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXE2DBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 23:01:00 -0400
Received: from mail.fieldses.org ([66.93.2.214]:33412 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbXE2DBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 23:01:00 -0400
Date: Mon, 28 May 2007 23:00:50 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de,
       nfs@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [NFS] [PATCH] NFSD: fix uninitialized variable
Message-ID: <20070529030050.GB20631@fieldses.org>
References: <20070527103442.GA10594@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070527103442.GA10594@havoc.gtf.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 06:34:42AM -0400, Jeff Garzik wrote:
> 
> Unlike many of the bogus warnings spewed by gcc, this one actually
> complains about a real bug:

No, the calls to posix_acl_valid() in nfs4_acl_posix_to_nfsv4() ensure
that the passed-in acl has ACL_USER_OBJ, ACL_GROUP_OBJ, and ACL_OTHER
entries, and hence that these fields will always be initialized.

But I don't want anyone else wasting their time on this.  Should we cave
in and add the initialization here just to shut up gcc?  Or would a
comment here help?

--b.

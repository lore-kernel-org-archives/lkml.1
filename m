Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbXJ0P4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbXJ0P4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXJ0P4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:56:42 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:34683 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbXJ0P4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:56:41 -0400
X-Greylist: delayed 2041 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Oct 2007 11:56:40 EDT
Date: Sat, 27 Oct 2007 11:22:27 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, sfrench@samba.org,
       Andrew Morton <akpm@linux-foundation.org>, vandrove@vc.cvut.cz
Subject: Re: Networked filesystems vs backing_dev_info
Message-ID: <20071027152227.GE3200@cs.cmu.edu>
Mail-Followup-To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	David Howells <dhowells@redhat.com>, sfrench@samba.org,
	Andrew Morton <akpm@linux-foundation.org>, vandrove@vc.cvut.cz
References: <1193477666.5648.61.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193477666.5648.61.camel@lappy>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 11:34:26AM +0200, Peter Zijlstra wrote:
> I had me a little look at bdi usage in networked filesystems.
> 
>  NFS, CIFS, (smbfs), AFS, CODA and NCP
> 
> And of those, NFS is the only one that I could find that creates
> backing_dev_info structures. The rest seems to fall back to
> default_backing_dev_info.

While a file is opened in Coda we associate the open file handle with a
local cache file. All read and write operations are redirected to this
local file and we even redirect inode->i_mapping. Actual reads and
writes are completely handled by the underlying file system. We send the
new file contents back to the servers only after all local references
have been released (last-close semantics).

As a result, there is no need for backing_dev_info structures in Coda,
if any congestion control is needed it will be handled by the underlying
file system where our locally cached copies are stored.

Jan

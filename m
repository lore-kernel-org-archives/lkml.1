Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbXJ0PdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbXJ0PdR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756470AbXJ0Pcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:32:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43245 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbXJ0Pcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:32:53 -0400
Subject: Re: Networked filesystems vs backing_dev_info
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, sfrench@samba.org,
       Andrew Morton <akpm@linux-foundation.org>, vandrove@vc.cvut.cz
In-Reply-To: <20071027152227.GE3200@cs.cmu.edu>
References: <1193477666.5648.61.camel@lappy>
	 <20071027152227.GE3200@cs.cmu.edu>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 17:32:16 +0200
Message-Id: <1193499137.5648.70.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-10-27 at 11:22 -0400, Jan Harkes wrote:
> On Sat, Oct 27, 2007 at 11:34:26AM +0200, Peter Zijlstra wrote:
> > I had me a little look at bdi usage in networked filesystems.
> > 
> >  NFS, CIFS, (smbfs), AFS, CODA and NCP
> > 
> > And of those, NFS is the only one that I could find that creates
> > backing_dev_info structures. The rest seems to fall back to
> > default_backing_dev_info.
> 
> While a file is opened in Coda we associate the open file handle with a
> local cache file. All read and write operations are redirected to this
> local file and we even redirect inode->i_mapping. Actual reads and
> writes are completely handled by the underlying file system. We send the
> new file contents back to the servers only after all local references
> have been released (last-close semantics).
> 
> As a result, there is no need for backing_dev_info structures in Coda,
> if any congestion control is needed it will be handled by the underlying
> file system where our locally cached copies are stored.

Ok, that works. Thanks for this explanation!


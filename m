Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZAZV4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZAZV4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZAZVzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:55:52 -0500
Received: from verein.lst.de ([213.95.11.210]:55086 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbZAZVzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:55:51 -0500
Date: Mon, 26 Jan 2009 22:55:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: devpts multiple instances feedback
Message-ID: <20090126215542.GA20760@lst.de>
References: <20090103155209.GA17988@lst.de> <20090105210940.GA31629@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105210940.GA31629@us.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 01:09:40PM -0800, Sukadev Bhattiprolu wrote:
> Making the pts/ptmx node would certianly simplify the code. But we
> ended up with some of the complexity to preserve the legacy behavior.
> I believe there was some concern that the presence of a "shadow"
> ptmx node on older distros might affect rights management (eg: if
> the older distro which does not know about /dev/pts/ptmx, applied
> a security label to /dev/ptmx that label could be subverted by using
> /dev/pts/ptmx ?
> 
> That was also one of the reasons for the default 000 mode on the pts/ptmx
> device node

So just make it 000 but always created it.

> 
> |  - the 000 mode is very weird, given how the /dev/ptmx operates
> |    it doesn't really make much sense to have it different than 0666
> |    unless you want to disable ptys.
> |  - why does pts_sb_from_inode have to check s_magic, I can't see
> |    it ever used on an inode not from the devpts filesystem
> 
> If /dev/ptmx is not a symlink to pts/ptmx, we would need the s_magic
> check ? (eg: when called from devpts_new_index()). The check would
> not be needed if /dev/ptmx is always a symlink.

Ok, so it's for the /dev/ptmx node.  Just make that explicit by
passing down a paramter then.


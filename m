Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbXLGPcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbXLGPcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 10:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXLGPcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 10:32:39 -0500
Received: from mail.fieldses.org ([66.93.2.214]:60411 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbXLGPci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 10:32:38 -0500
Date: Fri, 7 Dec 2007 10:32:31 -0500
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
Subject: Re: NFSv2/3 broken exporting/mounting (permission denied) in
	2.6.24-rc4
Message-ID: <20071207153230.GA20872@fieldses.org>
References: <200712071054.lB7AscVW002471@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712071054.lB7AscVW002471@harpo.it.uu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2007 at 11:54:38AM +0100, Mikael Pettersson wrote:
> On Thu, 6 Dec 2007 21:20:41 -0500, Erez Zadok wrote:
> > I get a "permission denied" when trying to mount a localhost nfsv2/3
> > exported volume, on v2.6.24-rc4-124-gf194d13.  It works w/ nfsv4 mounting.
> > It worked fine in 2.6.24-rc3.  Here's a sequence of ops I tried:
> > 
> > # mount -t ext2 /dev/hdb1 /n/lower/b0
> > # exportfs -o no_root_squash,rw localhost:/n/lower/b0
> > # mount -t nfs -o nfsvers=3 localhost:/n/lower/b0 /mnt
> 
> I'm seeing something similar too. NFSv3 export of an ext3 partition
> to another machine in my lan fails (client gets permission denied)
> when the server runs 2.6.24-rc4. It worked fine in 2.6.24-rc3.
> 
> There's no NFSv4 of any kind on either client or server.

And you're not varying the client at all, you're only changing the
kernel version on the server?

There are literally no commits between v2.6.24-rc3 and v2.6.24-rc4 which
touch fs/nfsd/.  What filesystem are you exporting?  Are the nfs-utils
versions the same in both cases?

Also, could you get a network trace showing the failure?

--b.

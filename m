Return-Path: <linux-kernel-owner+w=401wt.eu-S1750868AbZIOECa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750868AbZIOECa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 00:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbZIOECY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 00:02:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:46093 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZIOECY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 00:02:24 -0400
Date: Tue, 15 Sep 2009 06:05:59 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joel Becker <Joel.Becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ocfs2-devel@oss.oracle.com
Subject: Re: [GIT PULL] ocfs2 changes for 2.6.32
Message-ID: <20090915060559.5b0a2574@infradead.org>
In-Reply-To: <alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
References: <20090911200458.GA15416@mail.oracle.com>
	<alpine.LFD.2.01.0909141417180.4950@localhost.localdomain>
	<20090914221434.GA4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141614350.4950@localhost.localdomain>
	<20090915000417.GC4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141727150.4950@localhost.localdomain>
	<20090915005417.GD4507@mail.oracle.com>
	<alpine.LFD.2.01.0909141828070.4950@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 19:01:06 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 14 Sep 2009, Joel Becker wrote:
> >
> > 	In the reflink discussion before, I proposed that a separate
> > copyfile() syscall could be written that uses the same ->reflink()
> > inode operation but allows degradation in the storage handling.
> 
> .. exactly how?
> 
> If you're talking about falling back to manually just copying the
> data, then nobody is interested in that. User space can do that
> better with a simple read-write loop or with splice, or whatever.
> There's no reaason what-so-ever to do that.
> 
> But the thing is, network filesystems may be able to do server-side 
> copies, and the point being that they can do so _without_
> transferring the data to the client (and back). And if we do
> 'copyfile' (under whatever name) for one filesystem, then I think we
> should strive to make sure that it's useful for other filesystems too.

COW filesystems like btrfs may also be able to do interesting things
with copyfile() btw by just sharing all data blocks COW.

That would make copyfile() useful for me, much more so than the network
filesystem side...

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

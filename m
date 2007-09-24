Return-Path: <linux-kernel-owner+w=401wt.eu-S1759328AbXIXNQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328AbXIXNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbXIXNQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:16:19 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41104 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbXIXNQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:16:17 -0400
Date: Mon, 24 Sep 2007 07:16:15 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, trond.myklebust@fys.uio.no, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/2] VFS: new fgetattr() file operation
Message-ID: <20070924131615.GN10625@parisc-linux.org>
References: <E1IZmze-0003q9-00@dorka.pomaz.szeredi.hu> <20070924123640.GA17409@infradead.org> <E1IZnM8-0003sG-00@dorka.pomaz.szeredi.hu> <20070924125948.GM10625@parisc-linux.org> <E1IZndW-0003uI-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IZndW-0003uI-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 03:06:06PM +0200, Miklos Szeredi wrote:
> A file isn't deleted while there are still links or open files
> refering to it.  So getting the attributes for a file with nlink==0 is
> perfectly valid while the file is still open.

Is it?  Why not just pretend that the attributes are wiped when the file
is deleted.  Effectively, they are, since they can't affect anything.

> If a network filesystem protocol can't handle operations (be it data
> or metadata) on an unlinked file, we must do sillirenaming, so that
> the file is not actually unlinked.

Or you could call getattr right before you unlink and cache the result
in the client.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759856AbXIIVET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbXIIVET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbXIIVEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:04:05 -0400
Received: from mail.fieldses.org ([66.93.2.214]:38309 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759343AbXIIVEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:04:04 -0400
Date: Sun, 9 Sep 2007 17:04:00 -0400
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, nfsv4@linux-nfs.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [NFSv4] 2.6.23-rc4 oops in nfs4_cb_recall...
Message-ID: <20070909210400.GA7136@fieldses.org>
References: <6278d2220709040405i4f816afemb3a44d9cd95f9cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220709040405i4f816afemb3a44d9cd95f9cc@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> When accessing a directory inode from a single other client, NFSv4
> callbacks catastrophically failed [1] on the NFS server with
> 2.6.23-rc4 (unpatched); clients are both 2.6.22 (Ubuntu Gutsy build).
> Seems not easy to reproduce, since this kernel was running smoothly
> for 7 days on the server.
> 
> What information will help track this down, or is there a known
> failure mechanism?

I haven't seen that before.

> I can map stack frames to source lines with objdump, if that helps.

If it's still easy, it might help to figure out exactly where in
xprt_reserve() it died, and why.  If we've got some race that can lead
to freeing the client while a callback is in progress, then perhaps this
is on the first dereference of xprt?

--b.

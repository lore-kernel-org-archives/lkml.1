Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbYGUHD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbYGUHD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 03:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYGUHDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 03:03:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44203 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbYGUHDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 03:03:51 -0400
Date: Mon, 21 Jul 2008 08:03:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
Message-ID: <20080721070346.GA28946@ZenIV.linux.org.uk>
References: <4881BEF4.2020201@cn.fujitsu.com> <20080719131317.GA7027@asus> <20080719131909.GB7027@asus> <20080721052713.GY28946@ZenIV.linux.org.uk> <48842CDB.1090009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48842CDB.1090009@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 02:29:47PM +0800, Li Zefan wrote:
> > FWIW, it _is_ a good question.
> > 
> > 	* is all code treating ->mnt_devname as optional?  AFAICS, there's
> > at least one place in NFS that doesn't.  We could treat failing allocation
> > the same way we treat failing allocation of vfsmount itself - callers can
> > cope with that already.
> 
> I just did a cleanup, and the original code didn't check for NULL.

I know.

> I just looked into the git history, and I found out since fs/namespace.c was
> created in v2.4.10.4, the code has never changed to check for failing
> allocation of ->mnt_devname.

It used to have no users beyond fs/namespace.c itself and for _those_ the
thing had been optional, so leaving NULL had been OK.  Unfortunately, it
still had been a bad idea - new users had appeared and those predictably
didn't notice that fun detail.

The right thing here is to consider failing allocation of ->mnt_devname
as failure of the entire alloc.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbYGUHKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbYGUHKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 03:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYGUHJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 03:09:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:21603 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbYGUHJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 03:09:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XpAdS99S2nSP5SN98Opg/l13wrDt/bq2T8i2je4Ckxdzp52w9+zSJqhUNqILVgPlHX
         g419c2c6bHaiUyqdzZSFV7QiuSHFKsLoXt8gl6wlx7XfcWc9p0ppxviGb8IJMAzjxb4R
         9Uh004hHN9h7QrJReEomJgs7stNwDznrN7GvU=
Date: Mon, 21 Jul 2008 11:09:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
Message-ID: <20080721070950.GA6662@lenovo>
References: <4881BEF4.2020201@cn.fujitsu.com> <20080719131317.GA7027@asus> <20080719131909.GB7027@asus> <20080721052713.GY28946@ZenIV.linux.org.uk> <48842CDB.1090009@cn.fujitsu.com> <20080721070346.GA28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721070346.GA28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Al Viro - Mon, Jul 21, 2008 at 08:03:46AM +0100]
| On Mon, Jul 21, 2008 at 02:29:47PM +0800, Li Zefan wrote:
| > > FWIW, it _is_ a good question.
| > > 
| > > 	* is all code treating ->mnt_devname as optional?  AFAICS, there's
| > > at least one place in NFS that doesn't.  We could treat failing allocation
| > > the same way we treat failing allocation of vfsmount itself - callers can
| > > cope with that already.
| > 
| > I just did a cleanup, and the original code didn't check for NULL.
| 
| I know.
| 
| > I just looked into the git history, and I found out since fs/namespace.c was
| > created in v2.4.10.4, the code has never changed to check for failing
| > allocation of ->mnt_devname.
| 
| It used to have no users beyond fs/namespace.c itself and for _those_ the
| thing had been optional, so leaving NULL had been OK.  Unfortunately, it
| still had been a bad idea - new users had appeared and those predictably
| didn't notice that fun detail.
| 
| The right thing here is to consider failing allocation of ->mnt_devname
| as failure of the entire alloc.
|

Hi Al,

thanks a lot for comments! I think it is more then enough for now (i'm
about failing allocation in whole). If that happens and we are not able
to duplicate string - it's quite probable we will be in serious troubles
soon anyway ('cause of further kmalloc calls). So it's better to get
mount allocation fails then NULL deref.
 
		- Cyrill -

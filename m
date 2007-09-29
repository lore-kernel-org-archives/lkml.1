Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbXI2JYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbXI2JYg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 05:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbXI2JYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 05:24:30 -0400
Received: from verein.lst.de ([213.95.11.210]:35872 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbXI2JY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:24:29 -0400
Date: Sat, 29 Sep 2007 11:24:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, jblunck@suse.de,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, tiwai@suse.de
Subject: Re: [patch 09/10] Use struct path in fs_struct
Message-ID: <20070929092426.GA25343@lst.de>
References: <20070927141200.820970144@X40.localnet> <20070927141229.008500593@X40.localnet> <20070928184214.GI14269@lst.de> <200709282239.49088.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709282239.49088.agruen@suse.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 10:39:48PM +0200, Andreas Gruenbacher wrote:
> On Friday 28 September 2007 20:42, Christoph Hellwig wrote:
> > __d_path should probably switch to taking a struct path * aswell.
> 
> Indeed, it now easily can. Here we go...
> 
> 
> One less parameter to __d_path
> 
> All callers to __d_path pass the dentry and vfsmount of a struct
> path to __d_path. Pass the struct path directly, instead.

Looks good.  If you have some sparse time left the dentry and vfsmnt
arguments of __d_path and d_path should probably be switched over
to a struct path aswell.  For about half of the callers that works
out easily because they have a struct file, and some need some
reshuffling (e.g. /proc/ symlink code or the dcookies that want to
store a struct path aswell)


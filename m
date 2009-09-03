Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZICXXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZICXXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 19:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932475AbZICXXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 19:23:45 -0400
Received: from verein.lst.de ([213.95.11.210]:57786 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035AbZICXXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 19:23:44 -0400
Date: Fri, 4 Sep 2009 01:23:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, hch@lst.de, viro@zeniv.linux.org.uk,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
Message-ID: <20090903232317.GA6760@lst.de>
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com> <200908312119.12121.rjw@sisk.pl> <c4e36d110909010234i5f1b9357l805132137725a4f8@mail.gmail.com> <c4e36d110909031529q77b53122kdb85785ba293c478@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110909031529q77b53122kdb85785ba293c478@mail.gmail.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 12:29:04AM +0200, Zdenek Kabelac wrote:
> Ok - another bisect game played - and unexpected winner is:
> 
> (fat: add ->sync_fs)
> 
> f83d6d46e7adf241a064a4a425e5cd8a8fd8925f
> 
> Reverting this commit with current -rc8 kernel makes the system happy
> during the suspend/resume cycle. Obviously it has it price :) so just
> plain revert is probably not a good solution so the problem looks
> 'more serious'  (fat is not the only fs with this patch) thus adding
> original author to this thread.

Note that when you rever this patch on a current kernel you do actually
get different behvaviour than when going back to before this commit.

In 2.6.30 we called ->write_super in the various sync functions and
then ->sync_fs, in 2.6.31-rc8 you would not call any syncing at all
anymore.  I think this patch might just be a symptom for a situation
where the suspend code causes a sync and the mmc driver can't handle
it anymore.

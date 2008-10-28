Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYJ1QFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYJ1QFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYJ1QEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:04:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54621 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbYJ1QEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:04:52 -0400
Date: Tue, 28 Oct 2008 12:02:27 -0400 (EDT)
Message-Id: <20081028.120227.104028516.k-ueda@ct.jp.nec.com>
To: nikanth@gmail.com
Cc: dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com,
       James.Bottomley@hansenpartnership.com, j-nomura@ce.jp.nec.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       knikanth@suse.de, k-ueda@ct.jp.nec.com
Subject: Re: [dm-devel] [PATCH 11/13] dm: enable request-based dm
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <807b3a220810240052n6a8b41b0x1ea9c88124b3f5f8@mail.gmail.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	<20080912.104634.08318008.k-ueda@ct.jp.nec.com>
	<807b3a220810240052n6a8b41b0x1ea9c88124b3f5f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikanth,

On Fri, 24 Oct 2008 13:22:46 +0530, "Nikanth K" wrote:
> On Fri, Sep 12, 2008 at 8:16 PM, Kiyoshi Ueda wrote:
> > This patch enables request-based dm.
> >
> > o Request-based dm and bio-based dm coexist, since there are
> >  some target drivers which are more fitting to bio-based dm.
> >  Also, there are other bio-based devices in the kernel
> >  (e.g. md, loop).
> >  Since bio-based device can't receive struct request,
> >  there are some limitations on device stacking between
> >  bio-based and request-based.
> >
> >                     type of underlying device
> >                   bio-based      requeset-based
> >   ----------------------------------------------
> >    bio-based         OK                OK
> >    request-based     NG                OK
> >
> 
> So will some configurations would become impossible, if a target is
> made request-based and bio-based one is removed. Hope both
> types of targets would co-exist and would be selectable for sometime.

If the target is used anywhere in the device stack (e.g. linear),
both types of the target are needed, and that is possible.

As for multipath, see my another reply to your comment for PATCH 13.

Thanks,
Kiyoshi Ueda

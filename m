Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYIBVCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYIBVCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYIBVCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:02:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50653 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYIBVCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:02:22 -0400
Date: Tue, 2 Sep 2008 17:02:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH] UBIFS: fill f_fsid
Message-ID: <20080902210219.GA9856@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org> <1220194366-12731-13-git-send-email-dedekind@infradead.org> <1220262187.2982.58.camel@pmac.infradead.org> <20080901150147.GA20323@infradead.org> <1220339032.4036.31.camel@sauron> <20080902170954.GE3086@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080902170954.GE3086@webber.adilger.int>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 11:09:54AM -0600, Andreas Dilger wrote:
> The fsid is supposed to be a persistent, unique identifier for the
> filesystem, used by NFS in file handles.  Using st_dev is unsafe,
> because that may change from one server boot to the next, because
> of device probing order, driver changes, etc.  Also, not all filesystems
> HAVE a valid st_dev in the first place, which is the whole reason
> for this thread.
> 
> I think a ->get_fsid() export method would be preferable.

Umm, different things.  f_fsid in stat(v)fs is just a cookie exported to
userspac that has never really been documented.

We also called the filesystem part of the NFS filehandle in a few
places, and for those it's correct that it should be stable.  Currently
the fsid is either created from the dev_t in kernelspace or from
uuids extracted through libuuid in userspace.

I can't see anything in the message that started this thread that
mentions NFS, btw.

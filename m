Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYIBV00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYIBV00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYIBV0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:26:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:46102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYIBV0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:26:14 -0400
Subject: Re: [PATCH] UBIFS: fill f_fsid
From: David Woodhouse <dwmw2@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Dilger <adilger@sun.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <20080902210219.GA9856@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
	 <1220262187.2982.58.camel@pmac.infradead.org>
	 <20080901150147.GA20323@infradead.org> <1220339032.4036.31.camel@sauron>
	 <20080902170954.GE3086@webber.adilger.int>
	 <20080902210219.GA9856@infradead.org>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 22:26:09 +0100
Message-Id: <1220390769.2985.6.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 17:02 -0400, Christoph Hellwig wrote:
> On Tue, Sep 02, 2008 at 11:09:54AM -0600, Andreas Dilger wrote:
> > The fsid is supposed to be a persistent, unique identifier for the
> > filesystem, used by NFS in file handles.  Using st_dev is unsafe,
> > because that may change from one server boot to the next, because
> > of device probing order, driver changes, etc.  Also, not all filesystems
> > HAVE a valid st_dev in the first place, which is the whole reason
> > for this thread.
> > 
> > I think a ->get_fsid() export method would be preferable.
> 
> Umm, different things.  f_fsid in stat(v)fs is just a cookie exported to
> userspac that has never really been documented.
> 
> We also called the filesystem part of the NFS filehandle in a few
> places, and for those it's correct that it should be stable.  Currently
> the fsid is either created from the dev_t in kernelspace or from
> uuids extracted through libuuid in userspace.

Or from the f_fsid returned in statfs(), as of a week or so ago.

> I can't see anything in the message that started this thread that
> mentions NFS, btw.

That was Artem's motivation for filling in f_fsid in the first place.
Does anything else even _care_ about f_fsid? 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation




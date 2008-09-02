Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYIBRKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYIBRKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbYIBRKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:10:20 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:59527 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYIBRKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:10:18 -0400
Date: Tue, 02 Sep 2008 11:09:54 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] UBIFS: fill f_fsid
In-reply-to: <1220339032.4036.31.camel@sauron>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Message-id: <20080902170954.GE3086@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
 <1220262187.2982.58.camel@pmac.infradead.org>
 <20080901150147.GA20323@infradead.org> <1220339032.4036.31.camel@sauron>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 02, 2008  10:03 +0300, Artem Bityutskiy wrote:
> On Mon, 2008-09-01 at 11:01 -0400, Christoph Hellwig wrote:
> > > For btrfs I xor the first 64 bits with the second 64 bits, and put
> > > _that_ into f_fsid. You're just putting the first 64 bits in and
> > > ignoring the second 64 bits. Neither is really _better_ than the other;
> > > you just alter the circumstances in which you get collisions. But I
> > > suppose we might as well be consistent about how we do it?
> > 
> > XFS just puts in the st_dev.  And I can't realy find any useful
> > defintion of what it's supposed to b anyway..
> 
> For me this means that we should rather do what XFS does for
> consistency then.

The fsid is supposed to be a persistent, unique identifier for the
filesystem, used by NFS in file handles.  Using st_dev is unsafe,
because that may change from one server boot to the next, because
of device probing order, driver changes, etc.  Also, not all filesystems
HAVE a valid st_dev in the first place, which is the whole reason
for this thread.

I think a ->get_fsid() export method would be preferable.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


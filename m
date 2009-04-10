Return-Path: <linux-kernel-owner+w=401wt.eu-S936904AbZDJQgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936904AbZDJQgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765248AbZDJQg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:36:28 -0400
Received: from THUNK.ORG ([69.25.196.29]:47747 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763663AbZDJQg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:36:27 -0400
Date: Fri, 10 Apr 2009 12:36:20 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Alexander V. Lukyanov" <lav@yar.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1 vs 2.6.27.21 ext4 performance problem
Message-ID: <20090410163620.GA14814@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Alexander V. Lukyanov" <lav@yar.ru>, linux-kernel@vger.kernel.org
References: <20090410151235.GA9690@proxy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410151235.GA9690@proxy>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 07:12:35PM +0400, Alexander V. Lukyanov wrote:
> I have a server that is busy reading and writing several disks with
> ext4 fs.  After booting 2.6.29.1 kernel I have noticed significant
> increase in read rate.  I measure the read rate using a script which
> reads sysfs byte and access counts and calculates average per
> second.

Without knowing exactly what your workload is, it's hard to say for
sure.  One of the things which did go in after 2.6.27 was inode table
readahead.  The intent is to actually improve performance, although at
least initially it might mean a bit more I/O activity.

Does the differences go away if you do echo 0 into
/sys/fs/ext4/<dev>/inode_readahead_blks?

Are you seeing an increase in time, or decrease in transactions per
second, or just that there is is an increase in read rates?

	   	     	      	    	     - Ted

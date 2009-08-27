Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbZH0SuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbZH0SuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 14:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZH0SuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 14:50:22 -0400
Received: from verein.lst.de ([213.95.11.210]:60407 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbZH0SuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 14:50:22 -0400
Date: Thu, 27 Aug 2009 20:49:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, tytso@mit.edu, adilger@sun.com,
       swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, mfasheh@suse.com,
       joel.becker@oracle.com
Subject: Re: notes on volatile write caches vs fdatasync
Message-ID: <20090827184948.GA1367@lst.de>
References: <20090827011624.GA10405@lst.de> <20090827130252.GC14240@duck.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827130252.GC14240@duck.novell.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 03:02:52PM +0200, Jan Kara wrote:
>   I've noticed this as well when we were tracking some problems Pavel
> Machek found with his USB stick. I even wrote a patch at the time
>   http://osdir.com/ml/linux-ext4/2009-01/msg00015.html
> but it somehow died out. Now, the situation should be simpler with
> fsync paths cleaned up... BTW: People wanted this to be configurable per
> block device which probably makes sence...

Yeah, that patch is pretty ugly.  We need to do these cache flushes
in ->fsync (and ->sync_fs if any filesystem really doesn't guarantee to
issue  transaction there after data has been written).  Adding it
to simple_fsync too sounds good to me.

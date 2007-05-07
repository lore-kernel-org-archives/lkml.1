Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXEGBJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXEGBJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 21:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbXEGBJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 21:09:10 -0400
Received: from mga06.intel.com ([134.134.136.21]:54626 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752696AbXEGBJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 21:09:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,500,1170662400"; 
   d="scan'208";a="240116111"
Date: Sun, 6 May 2007 18:09:10 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: Kalpak Shah <kalpak@linsyssoft.com>,
       Karuna sagar K <karunasagark@gmail.com>, Amit Gud <gud@ksu.edu>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ChunkFS - measuring cross-chunk references
Message-ID: <20070507010910.GE12859@nifty>
References: <2e4afe1e0704221335y6d4c84d8id65e71826ce60acb@mail.gmail.com> <462B8D0C.7020509@ksu.edu> <2e4afe1e0704230019h3853bc82uae6c9b5cdc325ab9@mail.gmail.com> <1177320876.23226.7.camel@garfield> <20070423205333.GZ5967@schatzie.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423205333.GZ5967@schatzie.adilger.int>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 02:53:33PM -0600, Andreas Dilger wrote:
> 
> Also, is it considered a cross-chunk reference if a directory entry is
> referencing an inode in another group?  Should there be a continuation
> inode in the local group, or is the directory entry itself enough?

(Sorry for the delay; just moved to Portland these last couple of
weeks.)

It is a cross-chunk reference - we can't calculate the correct link
count for the target file unless we have a quick way to get all the
directory entries pointing to an inode.  My current scheme is to
create a continuation inode for the directory in the chunk containing
the inode (if the chunk containing the inode is full, create new
continuation inodes for both in a new chunk).

-VAL

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbXJ2Qaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbXJ2Qaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbXJ2Qah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:30:37 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:57946 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbXJ2Qag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:30:36 -0400
Message-ID: <47260AB1.9000003@zabbo.net>
Date: Mon, 29 Oct 2007 09:30:41 -0700
From: Zach Brown <zab@zabbo.net>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Anton Altaparmakov <aia21@cam.ac.uk>, Mike Waychison <mikew@google.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
References: <20071026233732.568575496@crlf.corp.google.com>	<E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk> <20071029101001.4378a7cf@think.oraclecorp.com>
In-Reply-To: <20071029101001.4378a7cf@think.oraclecorp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> And another of my pet peeves with ->bmap is that it uses 0 to mean  
>> "sparse" which causes a conflict on NTFS at least as block zero is  
>> part of the $Boot system file so it is a real, valid block...  NTFS  
>> uses -1 to denote sparse blocks internally.
> 
> Reiserfs and Btrfs also use 0 to mean packed.  It would be nice if there
> was a way to indicate your-data-is-here-but-isn't-alone.  But that's
> more of a feature for the FIEMAP stuff.

And maybe we can step back and see what the callers of FIBMAP are doing
with the results they're getting.

One use is to discover the order in which to read file data that will
result in efficient IO.

If we had an interface specifically for this use case then perhaps a
sparse block would be better reported as the position of the inode
relative to other data blocks.  Maybe the inode block number in ext* land.

This use is interesting to me because it can be useful for any file
system, particularly networked file systems.

- z

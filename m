Return-Path: <linux-kernel-owner+w=401wt.eu-S1751188AbZGREdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbZGREdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 00:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbZGREdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 00:33:06 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38723 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZGREdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 00:33:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Sat, 18 Jul 2009 00:31:55 -0400
From: Andreas Dilger <adilger@sun.com>
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
In-reply-to: <19041.4714.686158.130252@notabene.brown>
To: Neil Brown <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, dm-devel@redhat.com
Message-id: <20090718043155.GI4231@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <19041.4714.686158.130252@notabene.brown>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 18, 2009  10:08 +1000, Neil Brown wrote:
>  It has recently come to by attention that Linux on a 32 bit host does
>  not handle devices beyond 16TB particularly well.
> 
>  In particular, any access that goes through the page cache for the
>  block device is limited to a pgoff_t number of pages.
>  As pgoff_t is "unsigned long" and hence 32bit, and as page size is
>  4096, this comes to 16TB total.
:
:
>  I suppose we could add a CONFIG option to make pgoff_t be 
>  "unsigned long long".  Would the cost/benefit of that be acceptable?

I think the point is that for those people who want to use > 16TB
devices on 32-bit platforms (e.g. embedded/appliance systems) the
choice is between "completely non-functional" and "uses a bit more
memory per page", and the answer is pretty obvious.

For users who don't want to support this, they don't have to (just
like CONFIG_LBD or whatever), and for 64-bit systems it is irrelevant.
I think years ago we had the idea that it would be 64-bit everywhere
by now, and while that is true for many systems, embedded/appliance
systems will probably continue to be 32-bit for as long as they can.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


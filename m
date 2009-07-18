Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbZGRHsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbZGRHsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 03:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZGRHsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 03:48:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52559 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZGRHsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 03:48:17 -0400
Date: Sat, 18 Jul 2009 09:48:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Dilger <adilger@sun.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       device-mapper development <dm-devel@redhat.com>,
       Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Message-ID: <20090718074811.GA2682@basil.fritz.box>
References: <19041.4714.686158.130252@notabene.brown> <20090718043155.GI4231@webber.adilger.int> <871voewm6y.fsf@basil.nowhere.org> <20090718065213.GK4231@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090718065213.GK4231@webber.adilger.int>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 02:52:13AM -0400, Andreas Dilger wrote:
> If you aren't running a 32-bit system with this config, you shouldn't
> really care.  For those systems that need to run in this mode they
> would rather have it work a few percent slower instead of not at all.

Well, it doesn't work at all anyways due to the fsck problem.

> The last test numbers I saw were 5GB of RAM for a 20TB filesystem,
> but since the bitmaps used are fully-allocated arrays that isn't
> surprising.  We are planning to replace this with a tree, since the
> majority of bitmaps used by e2fsck have large contiguous ranges of
> set or unset bits and can be represented much more efficiently.

You would need to get <~2.5GB for 32bit. In practice that's
the limit you have there.

> Also, for filesystems like btrfs or ZFS the checking can be done
> online and incrementally without storing a full representation of
> the state in memory.

You could, but I suspect it would be cheaper to just use a
64bit system than to rewrite fsck. 64bit is available
for a lot of embedded setups these days too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

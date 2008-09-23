Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbYIWLv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbYIWLv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbYIWLvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:51:19 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53153 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYIWLvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:51:18 -0400
Date: Tue, 23 Sep 2008 05:50:45 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] ext4: Use preallocation when reading from the	inode
 table
In-reply-to: <20080923101613.58768083@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <20080923115045.GI10950@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <E1KhvsB-0002Ik-Ex@closure.thunk.org>
 <20080923101613.58768083@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 23, 2008  10:16 +0100, Alan Cox wrote:
> On Mon, 22 Sep 2008 20:35:23 -0400
> "Theodore Ts'o" <tytso@mit.edu> wrote:
> > With modern hard drives, reading 64k takes roughly the same time as
> > reading a 4k block.  So request adjacent inode table blocks to reduce
> > the time it takes when iterating over directories (especially when doing
> > this in htree sort order) in a cold cache case.  With this patch, the
> > time it takes to run "git status" on a kernel tree after flushing the
> > caches via "echo 3 > /proc/sys/vm/drop_caches", is reduced by 21%.
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Acked-by: Alan Cox <alan@redhat.com>
> 
> I'm actually suprised that 16 is the magic tuning number you've used and
> a bigger one isn't even more of a win

I was going to suggest making this at least a #defined constant instead
of hard coding the values there.  Making it a mount option and/or /proc
value would allow further testing.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


Return-Path: <linux-kernel-owner+w=401wt.eu-S965166AbXAaPzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965166AbXAaPzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965038AbXAaPzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:55:06 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35388 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965166AbXAaPzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:55:03 -0500
Date: Wed, 31 Jan 2007 07:34:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Mark Lord <lkml@rtr.ca>, Bron Gondwana <brong@fastmail.fm>,
       Mike Houston <mikeserv@bmts.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steve French <smfltc@us.ibm.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Daniel Drake <dsd@gentoo.org>, samba-technical@lists.samba.org,
       Vladimir Saveliev <vs@namesys.com>, reiserfs-dev@namesys.com,
       David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com
Subject: Re: How many people are using 2.6.16?
In-Reply-To: <20070131070237.GT3754@stusta.de>
Message-ID: <Pine.LNX.4.64.0701310728130.3632@woody.linux-foundation.org>
References: <45BE5948.6060403@redhat.com> <20070129160448.65fc63f3.mikeserv@bmts.com>
 <20070129221300.GC19422@brong.net> <20070130203933.GJ3754@stusta.de>
 <45BFF1F4.3060401@rtr.ca> <Pine.LNX.4.64.0701301748230.3611@woody.linux-foundation.org>
 <20070131070237.GT3754@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Jan 2007, Adrian Bunk wrote:
> 
> Regarding the longstanding CIFS/reiserfs/XFS problems, it seems the 
> status is:
> 
> CIFS:
> commit cb876f451455b6187a7d69de2c112c45ec4b7f99
>   Fix up CIFS for "test_clear_page_dirty()" removal
> queued for 2.6.19.3
> applies and compiles against 2.6.16
> 
> reiserfs:
> commit de14569f94513279e3d44d9571a421e9da1759ae
>   [PATCH] resierfs: avoid tail packing if an inode was ever mmapped
> backport to 2.6.16 required
> 
> XFS:
> fix not yet in your tree

Yes. The XFS problem should only be triggerable through O_DIRECT and 
non-O_DIRECT mmap at the same time, so the fix for that got pushed back as 
noncritical.

NOTE! I'm still not 100% sure about the older bdb corruption reports. Were 
they just noise due to other issues? Flaky RAM? One report of corruption 
was actually due to running my test-program without enough diskspace, so 
while that confused the issue for a while, it turned out to be a 
non-issue.

So I'm just saying that there might be other things lurking too. 

		Linus

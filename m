Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbZGDWEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbZGDWEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 18:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZGDWE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 18:04:26 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:55387 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZGDWEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 18:04:25 -0400
X-IronPort-AV: E=Sophos;i="4.42,349,1243814400"; 
   d="scan'208";a="337583287"
From: Roland Dreier <rdreier@cisco.com>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: Fix lockdep-reported AB-BA mutex issue
References: <adahbxwgwo6.fsf@cisco.com> <ada63ecdnpp.fsf@cisco.com>
	<4A4D0897.6060504@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 04 Jul 2009 15:04:25 -0700
In-Reply-To: <4A4D0897.6060504@linux.vnet.ibm.com> (Tyler Hicks's message of
	"Thu, 02 Jul 2009 14:20:55 -0500")
Message-ID: <adatz1syuja.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Jul 2009 22:04:29.0067 (UTC) FILETIME=[66EA8DB0:01C9FCF3]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > This patch looks good.  I really appreciate you tracking down and fixing
 > this problem.  It will take me a little bit longer before I can get to
 > the other 2 patches.

Thanks, so I'll assume that this patch has been queued up and will go
upstream at some point?

I'll resend the patch for removing the locking from
ecryptfs_destroy_crypt_stat() and ecryptfs_destroy_inode() with a proper
changelog and s-o-b.  Again, that patch is (almost by definition) not
fixing a real issue, since the lock problems that lockdep is warning
about must never occur for the same reason that the patch is valid,
namely that no other context will ever try to lock an object that is in
the process of being freed.

However, as you mentioned, it definitely is worth cleaning up lockdep
false positives because lockdep disables itself as soon as it prints one
report, and so fixing up ecryptfs makes lockdep much more useful for
debugging other stuff while still being able to use ecryptfs (as I like
to do on my laptop, since I'd just as soon not hand over all my files in
case my laptop is lost somehow).

I'll resend the s_vfs_rename_mutex annotation patch via the generic vfs
tree, since the change is really not in ecryptfs code at all (although
it is triggered by having a stacked filesystem).

Thanks,
  Roland

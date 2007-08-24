Return-Path: <linux-kernel-owner+w=401wt.eu-S934350AbXHXCem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350AbXHXCem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 22:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932484AbXHXCed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 22:34:33 -0400
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:63436 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbXHXCec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 22:34:32 -0400
Message-Id: <200708240233.AA00248@paprika.lab.ntt.co.jp>
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Fri, 24 Aug 2007 11:33:41 +0900
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: moriai.satoshi@lab.ntt.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       ecryptfs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Ecryptfs-devel] [PATCH] eCryptfs: fix possible fault in ecryptfs_sync_page
In-Reply-To: <20070823143745.GM22689@halcrow.austin.ibm.com>
References: <20070823143745.GM22689@halcrow.austin.ibm.com>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007, Michael Halcrow write:
>Note that there are other outstanding issues with eCryptfs on NFS. For
>instance, prepare_write()/commit_write() have gone away in -mm,
>leading to an oops when eCryptfs tries to call them directly

Yes, I certainly encountered the problem during testing eCryptfs on -mm,
and found Nick Piggin's new aops patchset lacks changes for eCryptfs.

>which is 
>well deserved, since eCryptfs really should not be doing that. Unionfs
>has just two places where it calls vfs_read() and vfs_write()
>respectively; eCryptfs is a bit more complex, with multiple write
>paths that end up writing encrypted data and updating metadata in the
>header. I am currently trying to find a way to convert everything over
>to vfs_read() and vfs_write() in eCryptfs, in a way that does not
>ultimately result in a kernel hang.

OK, I understand the reason and your plan.  Thanks for letting me know!
As you say, I honestly felt that it's a difficult task to write
stackable filesystems using low level operations.
It's good idea to replace them with the vfs functions.

So, how long does it take for the conversion, do you think?
Though I'm currenty focussing on eCryptfs in mainline,
I'd like to shift my focus to the new one if it's preferable.

Regards,
Ryusuke Konishi

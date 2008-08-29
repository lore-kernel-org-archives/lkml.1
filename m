Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYH2G0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYH2G0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYH2GXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:23:37 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:46837 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbYH2GXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:23:34 -0400
Message-Id: <200808290629.AA00218@capsicum.lab.ntt.co.jp>
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Fri, 29 Aug 2008 15:29:35 +0900
To: Jorn Engel <joern@logfs.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
In-Reply-To: <20080827181904.GD1371@logfs.org>
References: <20080827181904.GD1371@logfs.org>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jorn

I'll reply from the latter mail.

On Wed, 27 Aug 2008 20:19:04 +0200,  Jorn Engel wrote:
>More questions.  I believe the first two answer are no, but would like
>to be sure.
>Do you support compression?

No. (as you guessed)

>Do you do wear leveling or scrubbing?

NILFS does not support scrubbing. (as you guessed)
Under the current GC daemon, it writes logs sequentially and circularly
in the partition, and as you know, this leads to the wear levelling
except for superblock.

>How does garbage collection work?  In particular, when the filesystem
>runs out of free space, do you depend on the userspace daemon to make
>some policy decisions or can the kernel make progress on its own?

The GC of NILFS depends on the userspace daemon to make policy decisions.
NILFS cannot reclaim disk space on its own though it can work 
(i.e. read, write, or do other operations) without the daemon.
After it runs out of free space, disk full errors will be returned
until GC makes new space.

But, usually the GC will make enough disk space in the background
before that occurs.
The userland GC daemon, which runs in the background, starts to reclaim
logs (to be presice segments) if there are logs (segments) whose age
is older than a certain period, which we call ``protection period''. 
If no recent logs are found, it goes sleeping.

Regards,
Ryusuke

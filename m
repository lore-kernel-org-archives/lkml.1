Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbXENUpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbXENUpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbXENUpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:45:43 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:55777 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbXENUpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:45:42 -0400
Date: Mon, 14 May 2007 22:38:46 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  2/14] Add a new mount flag (MNT_UNION) for union
 mount
In-Reply-To: <20070514093902.GD4139@in.ibm.com>
Message-ID: <Pine.LNX.4.61.0705142237270.9570@yvahk01.tjqt.qr>
References: <20070514093722.GB4139@in.ibm.com> <20070514093902.GD4139@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 15:09, Bharata B Rao wrote:
>
>Introduce MNT_UNION, MS_UNION and FS_WHT flags. There are the necessary flags
>for doing
>
>    mount /dev/hda3 /mnt -o union
>
>You need additional patches for util-linux for that to work.
>
>Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
>Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
>---
> 
>+	/* Unions couldn't be writable if the filesystem
>+	 * doesn't know about whiteouts */
>+	err = -ENOTSUPP;
>+	if ((mnt_flags & MNT_UNION) &&
>+	    !(newmnt->mnt_sb->s_flags & MS_RDONLY) &&
>+	    !(newmnt->mnt_sb->s_type->fs_flags & FS_WHT))
>+		goto unlock;
>+

Maybe I am too biased towards unionfs/aufs, but if I have an {rw,rw} union
with whiteouts disabled (delete=all in unionfs speak), then FS_WHT
does not need to be supported. Your patches do not seem to do
delete=all semantics, do they?

	Jan
-- 

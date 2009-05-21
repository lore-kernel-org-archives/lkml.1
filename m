Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZEUNEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZEUNEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZEUNEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:04:01 -0400
Received: from sith.mimuw.edu.pl ([193.0.96.4]:57972 "EHLO sith.mimuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbZEUNEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:04:00 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 May 2009 09:04:00 EDT
Date: Thu, 21 May 2009 14:54:19 +0200
From: Jan Rekorajski <baggins@sith.mimuw.edu.pl>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Message-ID: <20090521125419.GM30663@sith.mimuw.edu.pl>
Mail-Followup-To: Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
	Jan Blunck <jblunck@suse.de>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz,
	vaurora@redhat.com
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
X-Operating-System: Linux 2.6.28.9 x86_64
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009, Jan Blunck wrote:

> Here is another post of the VFS based union mount implementation.

Is there any chance this will support NFS? I can union-mount tmpfs over
nfs mounted fs, but if I try to mount --union two NFS filesystems I
always get -EBUSY on second mount on the same mountpoint.

Something along these lines:

doesn't matter if I use --union on first mount, the result is always the
same.

mount <--union> -t nfs server:/export/system /mnt
OK
mount --union -t nfs server:/export/profile /mnt
mount.nfs: /mnt is busy or already mounted

I patched mount.nfs so it knows about MS_UNION, and strace shows me that
it passes that flag to kernel.

Jan
-- 
Jan Rekorajski            |  ALL SUSPECTS ARE GUILTY. PERIOD!
baggins<at>mimuw.edu.pl   |  OTHERWISE THEY WOULDN'T BE SUSPECTS, WOULD THEY?
BOFH, MANIAC              |                   -- TROOPS by Kevin Rubio

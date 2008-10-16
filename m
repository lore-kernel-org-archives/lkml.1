Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYJPQav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYJPQav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYJPQam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:30:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57342 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYJPQam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:30:42 -0400
Date: Thu, 16 Oct 2008 18:30:41 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: linux-kernel@vger.kernel.org
Subject: race condition in umount/statfs
Message-ID: <20081016163041.GB12174@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I've found that when umount command calls umount2() the process stays in
umount2() call till caches are flushed but entry in /etc/mtab is removed
after umount returns from umount2(). When df is invoked in the meantime,
it just returns statfs() for path from mtab, but as the filesystem
is not mounted in kernel anymore, you get statistics for another
filesystem instead (most likely /).

Example:  mount a usb flashdisk, copy some files there and then umount.
Cache flush on my machines is about 10 seconds.

As an fix I could call statfs() on parent directory and compare f_fsid, but
the manual says its set to zero on NFS and some systems.

--
metan

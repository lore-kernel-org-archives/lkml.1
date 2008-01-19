Return-Path: <linux-kernel-owner+w=401wt.eu-S932481AbYASQE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbYASQE7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 11:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760612AbYASQEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 11:04:49 -0500
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:35080 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698AbYASQEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 11:04:47 -0500
Date: Sat, 19 Jan 2008 18:05:15 +0200 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc1
To: Miklos Szeredi <miklos@szeredi.hu>
cc: util-linux-ng@vger.kernel.org, akpm@linux-foundation.org,
       hch@infradead.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch] util-linux-ng: unprivileged mounts support
In-Reply-To: <E1JF7Xh-0003q3-Qv@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.61.0801191745520.4482@dhcppc1>
References: <E1JF7Xh-0003q3-Qv@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Jan 2008, Miklos Szeredi wrote:

> This is an experimental patch for supporing unprivileged mounts and
> umounts.  

User unmount unfortunately still doesn't work if the kernel doesn't have 
the unprivileged mount support but as we discussed this in last July that 
shouldn't be needed for this case.

  % mount -t ntfs-3g /dev/hda10 /tmp/test
  % cat /proc/mounts | grep /tmp/test                                                                         
  /dev/hda10 /tmp/test fuseblk rw,nosuid,nodev,user_id=501,group_id=501,allow_other 0 0
  % mount | grep /tmp/test
  /dev/hda10 on /tmp/test type fuseblk (rw,nosuid,nodev,allow_other,blksize=1024,user=szaka)
  % umount /tmp/test
  umount: /dev/hda10: not mounted
  umount: /tmp/test: must be superuser to umount
  umount: /dev/hda10: not mounted
  umount: /tmp/test: must be superuser to umount

	Szaka

--
NTFS-3G:  http://ntfs-3g.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbYEAQ1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbYEAQ1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761829AbYEAQ1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:27:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28018 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761803AbYEAQ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:27:06 -0400
From: Chris Mason <chris.mason@oracle.com>
To: jeffschroeder@computer.org
Subject: Re: Btrfs v0.14 Released
Date: Thu, 1 May 2008 12:26:55 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <200804291601.32945.chris.mason@oracle.com> <200805011204.20847.chris.mason@oracle.com> <c24352ca0805010918j395470d0o8f2088571c90183b@mail.gmail.com>
In-Reply-To: <c24352ca0805010918j395470d0o8f2088571c90183b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011226.56076.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2008, Jeff Schroeder wrote:
> On Thu, May 1, 2008 at 9:04 AM, Chris Mason <chris.mason@oracle.com> wrote:
> > On Tuesday 29 April 2008, Chris Mason wrote:
> >  > Hello everyone,
> >  >
> >  > Btrfs v0.14 is now available for download.  Please note the disk
> >  > format has changed, and it is not compatible with older versions of
> >  > Btrfs.
> >  >
> >  > For downloads and documention, please see the Btrfs project page:
> >  >
> >  > http://btrfs.wiki.kernel.org
> >
> >  Hello everyone,
> >
> >  I've rolled up some fixes for older kernels and fixed an uninitialized
> >  variables in btrfs-progs that could cause an oops on mount.  I'll wait a
> > few days to see if other bug reports come in and cut a 0.15 with any
> > other critical fixes.
>
> Well it oopses on writes everytime in Ubuntu 8.04 (Hardy). I'd planned
> on digging into
> it more before spending a bug report, but will send it tonight after
> getting to the affected
> machine.

This is because ubuntu kernels ship with apparmor, you'll need this patch:

If there is a #ifdef IM_A_UBUNTU_KERNEL I can use, I'll do it.  Jeff Mahoney 
has a similar patch for SUSE that I've been meaning to merge, but I wanted to 
lookup some way to check for ubuntu as well.

-chris

diff -r e7da2489b19b file.c
--- a/file.c	Wed Apr 30 13:59:35 2008 -0400
+++ b/file.c	Thu May 01 12:25:11 2008 -0400
@@ -852,7 +852,7 @@ static ssize_t btrfs_file_write(struct f
 		goto out_nolock;
 	if (count == 0)
 		goto out_nolock;
-	err = remove_suid(fdentry(file));
+	err = remove_suid(&file->f_path);
 	if (err)
 		goto out_nolock;
 	file_update_time(file);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbXCTUwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbXCTUwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbXCTUwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:52:46 -0400
Received: from washoe.rutgers.edu ([165.230.95.67]:57844 "EHLO
	smtp.onerussian.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbXCTUwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:52:44 -0400
Date: Tue, 20 Mar 2007 16:52:36 -0400
From: Yaroslav Halchenko <yoh@psychology.rutgers.edu>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Jesper Juhl <jesper.juhl@gmail.com>
Message-ID: <20070320205236.GK29757@washoe.onerussian.com>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Jesper Juhl <jesper.juhl@gmail.com>
References: <20070223223200.GN26338@washoe.onerussian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223223200.GN26338@washoe.onerussian.com>
X-URL: http://www.onerussian.com
X-Image-Url: http://www.onerussian.com/img/yoh.png
X-PGP-Key: http://www.onerussian.com/gpg-yoh.asc
X-fingerprint: 3BB6 E124 0643 A615 6F00  6854 8D11 4563 75C0 24C8
User-Agent: mutt-ng/devel-r804 (Debian)
X-SA-Exim-Connect-IP: 192.168.100.6
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, jesper.juhl@gmail.com
X-SA-Exim-Mail-From: yoh@washoe.rutgers.edu
Subject: Re: nfs_update_inode: inode X mode changed, Y to Z
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on smtp.onerussian.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kernel People,

Problem persists and it seems that I am not alone who hits this problem:
http://lkml.org/lkml/2007/3/1/53

in my case it happens if there is a lot (>50) nfs clients which in a
fast pace create a small file, close it and then open it for reading.
Some times it fails saying that the file is a directory, some times it
just fails to open it for writing, etc

I would really appreciate any comments and/or ideas on how to
troubleshoot/eliminate this issue.

Cheers
Yarik


On Fri, 23 Feb 2007, Yaroslav Halchenko wrote:

> Dear Kernel People,

> I am running a tiny cluster (27 nodes). Setup is as follows:

> * NFS server:
>    kernel: vanilla 2.6.18.2 + areca drivers
>    mounted partition is XFS
>    nfs-kernel-server: 1.0.10-1~bpo.1 (from backports.org)

> * clients:
>    kernel: 2.6.17-2-amd64 (Debian stock from etch installed few months ago)

> Today under heavy load which consisted of the nodes manipulating tons of
> small files, I started to mention that software reported weird errors
> like:

> EOFError: EOF read where object expected
> mv: cannot stat <FILENAME> : No such file or directory
> etc

> Looking at the client's dmesg I found nasty:

> node17.ravana.rutgers.edu: Feb 23 13:32:06 node17 kernel: nfs_update_inode: inode 680223263 mode changed, 0042755 to 0100644
> node17.ravana.rutgers.edu: Feb 23 13:41:19 node17 kernel: nfs_update_inode: inode 681427742 mode changed, 0042755 to 0100644
> node22.ravana.rutgers.edu: Feb 22 22:58:15 node22 kernel: nfs_update_inode: inode 677306152 mode changed, 0042755 to 0100644
> node22.ravana.rutgers.edu: Feb 23 13:48:33 node22 kernel: nfs_update_inode: inode 681695507 mode changed, 0100644 to 0042755
> node12.ravana.rutgers.edu: Feb 23 13:31:01 node12 kernel: nfs_update_inode: inode 680150798 mode changed, 0100644 to 0042755
> node12.ravana.rutgers.edu: Feb 23 13:34:57 node12 kernel: nfs_update_inode: inode 680418141 mode changed, 0100644 to 0042755
> node12.ravana.rutgers.edu: Feb 23 13:37:01 node12 kernel: nfs_update_inode: inode 680637478 mode changed, 0100644 to 0042755
> node12.ravana.rutgers.edu: Feb 23 13:39:25 node12 kernel: nfs_update_inode: inode 681034087 mode changed, 0100644 to 0042755
> node12.ravana.rutgers.edu: Feb 23 13:40:06 node12 kernel: nfs_update_inode: inode 681225056 mode changed, 0042755 to 0100644
> node12.ravana.rutgers.edu: Feb 23 13:43:26 node12 kernel: nfs_update_inode: inode 681474682 mode changed, 0100644 to 0042755
> ......

> server logs didn't show any abnormal things... where should I look for the
> source of the problem? googling up seems to be of no interesting result...
> is there way to eliminate cause may be by tuning some performance
> parameters (ie sacrificing performance for stability)?

> Thanks everyone in advance for hints
-- 
Yaroslav Halchenko
Research Assistant, Psychology Department, Rutgers-Newark
Student  Ph.D. @ CS Dept. NJIT
Office: (973) 353-5440x263 | FWD: 82823 | Fax: (973) 353-1171
        101 Warren Str, Smith Hall, Rm 4-105, Newark NJ 07102
WWW:     http://www.linkedin.com/in/yarik        

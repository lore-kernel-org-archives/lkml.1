Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbYDRNM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbYDRNM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbYDRNMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:12:20 -0400
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:53951 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYDRNMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:12:19 -0400
Date: Fri, 18 Apr 2008 16:13:47 +0300 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@dhcppc2
To: david@lang.hm
cc: Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
In-Reply-To: <alpine.DEB.1.10.0804141326020.13255@asgard>
Message-ID: <Pine.LNX.4.61.0804181603230.29728@dhcppc2>
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
 <20080414091639.4bd3879d@core> <20080414084141.GA29113@infradead.org>
 <200804141020.37271.chris.mason@oracle.com> <alpine.DEB.1.10.0804141326020.13255@asgard>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 14 Apr 2008 david@lang.hm wrote:

> and the various interactions and deadlocks that can happen with a
> userspace filesystem, such as swapping to it)

Swap on loopback could deadlock with whatever file system, not only FUSE.

The correct and safe way to use swap with FUSE is using the fuseblk fstype 
and a swap file on the FUSE file system (so it's exactly the same as one 
would do with an in-kernel file system). This completely avoids the usage 
of user space during swapping. This is in use for over a year with ntfs-3g, 
e.g. by Knoppix and Mr Klaus Knopper wrote only positive things to me so 
far.

	Szaka

-- 
NTFS-3G:  http://ntfs-3g.org

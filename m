Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbXKOVyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbXKOVyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbXKOVy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:54:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754617AbXKOVy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:54:27 -0500
Date: Thu, 15 Nov 2007 13:53:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
Message-Id: <20071115135332.5a007334.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0711152238180.19853@twin.jikos.cz>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0711141728290.15844@twin.jikos.cz>
	<20071114083906.178232cb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0711141740110.15844@twin.jikos.cz>
	<Pine.LNX.4.64.0711141758570.15844@twin.jikos.cz>
	<20071114181948.GA15240@kroah.com>
	<20071115192319.GA30186@kroah.com>
	<Pine.LNX.4.64.0711152238180.19853@twin.jikos.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 22:41:41 +0100 (CET)
Jiri Kosina <jikos@jikos.cz> wrote:

> On Thu, 15 Nov 2007, Greg KH wrote:
> 
> > This patch, as found by Dave Young, should fix the issue: I'll roll it 
> > into my larger patchset so that Andrew will get it automatically next 
> > release, but here it is for people to use now.
> 
> Hmm, something strange going on here. With this patch applied on top of 
> 2.6.24-rc2-mm1, I can't see no lockup or warning from kobjects code, which 
> is good. But this happens:
> 
> ...
> Creating device nodes with udev
> resume device  not found (ignoring)
> Waiting for device 
> /dev/disk/by-id/scsi-SATA_HDS722516VLSA80_VN6D3ECDE5BD9D-part6 to appear:  
> ok
> showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
> fsck 1.40.2 (12-Jul-2007)
> [/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a 
> /dev/disk/by-id/scsi-SATA_HDS722516VLSA80_VN6D3ECDE5BD9D-part6
> Error writing block 1542 (Attempt to write block from filesystem resulted 
> in short write).
> 
> /dev/disk/by-id/scsi-SATA_HDS722516VLSA80_VN6D3ECDE5BD9D-part6: UNEXPECTED 
> INCONSISTENCY; RUN fsck MANUALLY.
>         (i.e., without -a or -p options)
> Error writing block 1542 (Attempt to write block from filesystem resulted in short write).                                                                                         

Yup.  Please apply the fix from
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/hot-fixes

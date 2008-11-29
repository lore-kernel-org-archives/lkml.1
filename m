Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbYK2IY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbYK2IY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 03:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYK2IYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 03:24:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbYK2IYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 03:24:46 -0500
Date: Sat, 29 Nov 2008 00:24:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mingo@redhat.com, val.henson@gmail.com, matthew@wil.cx
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default
 behaviour
Message-Id: <20081129002419.abfd2504.akpm@linux-foundation.org>
In-Reply-To: <20081127170345.GA14991@infradead.org>
References: <20081126195457.GA3541@srcf.ucam.org>
	<20081126195824.GB3541@srcf.ucam.org>
	<492DD035.5020705@oracle.com>
	<20081127150126.GA20941@srcf.ucam.org>
	<20081127150341.GB20941@srcf.ucam.org>
	<20081127170345.GA14991@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008 12:03:46 -0500 Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Nov 27, 2008 at 03:03:41PM +0000, Matthew Garrett wrote:
> > Add support for defaulting to relatime
> >     
> > Allow the kernel to enable relatime on all mounts by default. This can be
> > configured at build time or by a kernel parameter or sysctl. Also add a
> > MS_NORELATIME mount option to allow the default to be overridden for specific
> > mount points.
> 
> NACK.  Please just do it in fstab.
> 

Yes, that's what I was wondering.  No /proc thingy, no new Kconfig
entries, no __setup() thing.  Just

	mount -o relatime=$((24*60*60)) /dev/sda1 /mnt/point
	mount -o remount,relatime=$((24*60*60)) /dev/sda1 /mnt/point

?

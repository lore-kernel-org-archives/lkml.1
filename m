Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbZAQGDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbZAQGDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 01:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZAQGDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 01:03:20 -0500
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:38151 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZAQGDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 01:03:20 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs: some inode attrs, and a question 
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
In-Reply-To: <1232125169.15209.19.camel@norville.austin.ibm.com>
References: <7471.1231827621@jrobl> <1231852628.6954.4.camel@norville.austin.ibm.com> <496FAFE2.8020102@linux.vnet.ibm.com> <9829.1232091366@jrobl> <1232125169.15209.19.camel@norville.austin.ibm.com>
Date: Sat, 17 Jan 2009 15:03:12 +0900
Message-ID: <7210.1232172192@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave Kleikamp:
> I think you're hitting on something here.  I never understood  the need
> for the d_drop()s, but taking them out broke things.  They probably are
> just papering over bugs where the ecryptfs inode is not being properly
> updated after changes are made to the lower inode.

As long as cifs_hardlink() calls d_drop() for the target dentry (as the
old version of NFS did), ecryptfs may have to call d_drop() too. But I
believe the d_drop() for the source dentry is unnecessary, as long as
the inode attributes are maintained correctly.
Additionally, when the lower filesystem does NOT call d_drop(), ecryptfs
has no necessary to call it. I'd like to suggest ecryptfs_link() to
check it by d_unhashed().


J. R. Okajima

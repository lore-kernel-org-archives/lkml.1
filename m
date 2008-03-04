Return-Path: <linux-kernel-owner+w=401wt.eu-S1761714AbYCDJ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714AbYCDJ1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbYCDJ1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:27:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954AbYCDJ1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:27:00 -0500
Date: Tue, 4 Mar 2008 01:26:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Patch: romfs_lookup always failed in linux-2.6.25-rc3-git3
Message-Id: <20080304012621.b84fc769.akpm@linux-foundation.org>
In-Reply-To: <20080303173620.GA9243@freya.fugue.com>
References: <20080303173620.GA9243@freya.fugue.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 09:36:20 -0800 "Adam J. Richter" <adam@yggdrasil.com> wrote:

> Hi David,
> 
> 	romfs_lookup worked in 2.6.24.2, but always fails in
> linux-2.6.25-rc3-git3.  fs/romfs/inode.c is the same in at least
> 2.6.25-rc3 through 2.6.25-rc3-git4 and the latest sources from git, so
> these versions almost certainly have the same problem.
> 
> 	The bug appears to be from a well meaning but botched attempt
> to eliminate a goto from romfs_lookup.  Previously, a goto statement
> was used to skip over "inode = NULL;" when the lookup succeeded.  In
> the 2.6.25-rc3 version, inode is set to NULL even when an inode was
> found, so the result is the the lookup always appears to fail.
> 
> 	 The attached patch fixes the problem while still eliminating
> the goto.  The patch adds one line and replaces one line.  It only
> looks big because I've set the number of context lines to 10 for
> better readability.  I have tested it in on a romfs initial ramdisk
> which on which I had experienced the problem.
> 
> 	If this patch looks OK to you, can you please submit it
> upstream?

Thanks.

> P.S. romfs_lookup casts a valid pointer to an int and then back again
> with res = PTR_ERR(inode);...return ERR_PTR(res).  This may break on
> arhictectures where sizeof(int) < sizeof(pointer).  If I want to submit
> a subsequent fix for this, are you the person I should the patch to?

I can take care of it.

Please remember the signed-off-by: red tape.

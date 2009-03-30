Return-Path: <linux-kernel-owner+w=401wt.eu-S1759657AbZC3Var@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbZC3Var (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbZC3VaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:30:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756754AbZC3VaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:30:04 -0400
Date: Mon, 30 Mar 2009 14:22:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: avishay@gmail.com, jeff@garzik.org, linux-fsdevel@vger.kernel.org,
       osd-dev@open-osd.org, zbr@ioremap.net,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, linux-next@vger.kernel.org
Subject: Re: [PATCHSET 0/8 version 4] exofs for kernel 2.6.30
Message-Id: <20090330142200.af4b497c.akpm@linux-foundation.org>
In-Reply-To: <49C1331D.1080805@panasas.com>
References: <49C1331D.1080805@panasas.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 19:45:01 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> What's new since last iteration:
> 
> * I completely re-wrote the [PATCH 4/8] exofs: address_space_operations
>   in which we actually write/read to/from osd-storage. The difference is
>   that now we try to accumulate as many contiguous pages as possible and
>   send them as one large request. As opposed to writing each page at a
>   time, in the previous patchset.
> 
> * [PATCH 5/8] exofs: dir_inode and directory operations received lots
>   of love thanks to Evgeniy Polyakov's grate comments.
> 
> exofs is a file system that uses an OSD device as it's back store.
> 
> OSD is a new T10 command set that views storage devices not as a large/flat
> array of sectors but as a container of objects, each having a length, quota,
> time attributes and more. Each object is addressed by a 64bit ID, and is
> contained in a 64bit ID partition. Each object has associated attributes
> attached to it, which are integral part of the object and provide metadata about
> the object. The standard defines some common obligatory attributes, but user
> attributes can be added as needed.
> 
> Here is the list of patches
> [PATCH 1/8] exofs: Kbuild, Headers and osd utils
> [PATCH 2/8] exofs: file and file_inode operations
> [PATCH 3/8] exofs: symlink_inode and fast_symlink_inode operations
> [PATCH 4/8] exofs: address_space_operations
> [PATCH 5/8] exofs: dir_inode and directory operations
> [PATCH 6/8] exofs: super_operations and file_system_type
> [PATCH 7/8] exofs: Documentation
> [PATCH 8/8] fs: Add exofs to Kernel build

Are all the prerequisites for exofs now in mainline?

> This patchset is also available on:
>   git-clone git://git.open-osd.org/linux-open-osd.git linux-next
> or on the web at:
>   http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=refs/heads/linux-next

Well I could merge them, but given that you have a git tree, a more
convenient path would be for us to include your tree in linux-next and
then you ask Linus to pull it directly when the time comes.

I'm unsure when that time will come.  Who has reviewed this work and
what was the result?



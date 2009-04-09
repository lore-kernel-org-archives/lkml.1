Return-Path: <linux-kernel-owner+w=401wt.eu-S935565AbZDIXix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935565AbZDIXix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZDIXin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:38:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097AbZDIXim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:38:42 -0400
Date: Thu, 9 Apr 2009 16:36:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: yur@emcraft.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] shmem: respect MAX_LFS_FILESIZE
Message-Id: <20090409163610.8619bfc7.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0904062155090.21044@blonde.anvils>
References: <Pine.LNX.4.64.0904062151250.21044@blonde.anvils>
	<Pine.LNX.4.64.0904062155090.21044@blonde.anvils>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 21:56:13 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> Question: couldn't the 32-bit kernel's MAX_LFS_FILESIZE be almost doubled?
> It limits the pagecache index to a signed long, but we use an unsigned long.

I expect it would be OK, yes.  The only failure mode I can think of is
if someone is using signed long as a pagecache index and I'd be pretty
surprised if we've made that mistake anywhere.  The potential for goofs
is higher down in filesystems, but they shouldn't be using pagecache
indices much at all.

Of course it does invite people to write applications which then fail
on older kernels, but such is life.


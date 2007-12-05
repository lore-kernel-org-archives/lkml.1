Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbXLEMCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbXLEMCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 07:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXLEMCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 07:02:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892AbXLEMCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 07:02:38 -0500
Date: Wed, 5 Dec 2007 04:02:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [NETNS]: Fix /proc/net breakage
Message-Id: <20071205040236.ff102b9e.akpm@linux-foundation.org>
In-Reply-To: <200712031900.lB3J0PR9025742@hera.kernel.org>
References: <200712031900.lB3J0PR9025742@hera.kernel.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 19:00:25 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2b1e300a9dfc3196ccddf6f1d74b91b7af55e416
> Commit:     2b1e300a9dfc3196ccddf6f1d74b91b7af55e416
> Parent:     e03ba84adb62fbc6049325a5bc00ef6932fa5e39
> Author:     Eric W. Biederman <ebiederm@xmission.com>
> AuthorDate: Sun Dec 2 00:33:17 2007 +1100
> Committer:  Herbert Xu <herbert@gondor.apana.org.au>
> CommitDate: Sun Dec 2 00:33:17 2007 +1100
> 
>     [NETNS]: Fix /proc/net breakage
>     
>     Well I clearly goofed when I added the initial network namespace support
>     for /proc/net.  Currently things work but there are odd details visible to
>     user space, even when we have a single network namespace.
>     
>     Since we do not cache proc_dir_entry dentries at the moment we can just
>     modify ->lookup to return a different directory inode depending on the
>     network namespace of the process looking at /proc/net, replacing the
>     current technique of using a magic and fragile follow_link method.
>     
>     To accomplish that this patch:
>     - introduces a shadow_proc method to allow different dentries to
>       be returned from proc_lookup.
>     - Removes the old /proc/net follow_link magic
>     - Fixes a weakness in our not caching of proc generic dentries.
>     
>     As shadow_proc uses a task struct to decided which dentry to return we can
>     go back later and fix the proc generic caching without modifying any code
>     that uses the shadow_proc method.

This patch caused the binfmt_misc regression reported in
http://bugzilla.kernel.org/show_bug.cgi?id=9504


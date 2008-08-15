Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYHOEwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYHOEwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 00:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbYHOEvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 00:51:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36212 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYHOEvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 00:51:52 -0400
Date: Fri, 15 Aug 2008 05:51:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: oops in proc_sys_compare
Message-ID: <20080815045149.GC28946@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0808141908290.15191@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808141908290.15191@blonde.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 07:31:06PM +0100, Hugh Dickins wrote:
> I got this oops below, after several hours of swap-heavy kernel builds
> in tmpfs, on 2.6.27-rc1-mm1 a couple of weeks ago.  Tried to reproduce
> it without success, then got a very similar trace (not saved) from
> 2.6.27-rc3 itself doing the same test yesterday: again oopsing in
> proc_sys_compare on address -16, looks like it's trying for
> PROC_I(dentry->d_inode)->sysctl but d_inode is NULL.
> 
> I looked to see what's been going on in fs/proc recently, and your
> [PATCH] sanitize proc_sysctl 9043476f726802f4b00c96d0c4f418dde48d1304
> does sound like it might be implicated.  I've only seen this on
> PowerPC G5, similar tests on x86_32 and _64 haven't shown it:
> maybe a memory barrier needed somewhere?
 
Bloody interesting.  We never create negative hashed dentries in there and
AFAICS we should never get d_delete() called on those...  Missing barrier
would mean serious trouble in dcache.c and not just for /proc/sys...

Are you sure about oops decoding?  At least disassembly of proc_sys_compare()
in the kernel image in question would be nice to see...

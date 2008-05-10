Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYEJUrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYEJUrk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 16:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYEJUrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 16:47:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50478 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbYEJUrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 16:47:32 -0400
Date: Sat, 10 May 2008 21:47:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 0/9] Fix resource leaks for exec related stuffs
Message-ID: <20080510204731.GK13907@ZenIV.linux.org.uk>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 09:52:25PM +0800, WANG Cong wrote:
> This patchset contains various fixes for fs/binfmt_*.c, fs/{exec, compat}.c.
> Most of them are aimed to fix resource leaks in failure path. Others
> are bug fixes in failure path.
> 
> All patches are tested on UML, except [5/9] and [6/9], since I don't have
> the desired environment to test them. It should be OK since [4/9] is the
> similar fix.

3/9 and 8/9 are OK, the rest is either not needed or broken (e.g. 4/9
ends up with double fput() in case of failure in prepare_binfmt(), etc.)

I've applied "fs/binfmt_elf.c: fix a wrong free", slightly simple fix
for lead covered by 3/9, and 8/9 as-is; all in vfs-2.6.git#vfs-2.6.25.

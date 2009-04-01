Return-Path: <linux-kernel-owner+w=401wt.eu-S1762096AbZDALuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096AbZDALuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbZDALt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:49:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55797 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbZDALt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:49:57 -0400
Date: Wed, 1 Apr 2009 12:49:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Cheng Renquan <crquan@gmail.com>
Subject: Re: [PATCH] Free the temporary vfsmount created in
	bdev_cache_init()
Message-ID: <20090401114955.GC28946@ZenIV.linux.org.uk>
References: <20090401110703.12974.99902.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401110703.12974.99902.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 12:07:37PM +0100, Catalin Marinas wrote:
> The vfsmount structure allocated in this function (the bd_mnt local
> variable) is only used to obtain the blockdev_superblock and there are
> no other references to it. This structure can be safely freed (and
> prevent kmemleak from reporting it).

NAK.  This kind of kludges is simply not worth doing.  Store the
pointer to vfsmount into a static-in-file variable if you want
to get kmemleak to STFU.

Savings on a vfsmount are not worth neurons needed to remember that
in this particular case we are OK to do something that is utterly
wrong in general (free_vfsmnt() is a very low-level stuff that shouldn't
be used outside of namespace.c and super.c).

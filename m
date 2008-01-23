Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYAWFxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYAWFxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 00:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYAWFxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 00:53:16 -0500
Received: from verein.lst.de ([213.95.11.210]:42808 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbYAWFxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 00:53:15 -0500
Date: Wed, 23 Jan 2008 06:47:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       sparclinux@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: 2.6.24-rc8-mm1: sparc64 warning at fs/file_table.c:49 __fput+0x1a8/0x1e0()
Message-ID: <20080123054747.GA14729@lst.de>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <200801222130.24136.m.kozlowski@tuxland.pl> <20080122130228.e7596163.akpm@linux-foundation.org> <1201043638.7585.47.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201043638.7585.47.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 03:13:58PM -0800, Dave Hansen wrote:
> The emergency remount code forcibly removes FMODE_WRITE from
> filps.  The r/o bind mount code notices that this was done
> without a proper mnt_drop_write() and properly gives a
> warning.
> 
> This patch does a mnt_drop_write() and also notes in the
> filp that this was done to suppress any warning that would
> have otherwise been triggered.
> 
> I also wonder if inode->i_writecount is made inconsistent
> by the emergency remount code.  I guess it is, but the
> damage is limited to a single inode instead of being
> visible more globally like the mnt write count.  Probably
> not really worth fixing.

The right fix is to not simply remove FMODE_WRITE, but just remove
this whole function.  Until we have a proper revoke it will cause more
harm than good.

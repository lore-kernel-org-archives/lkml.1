Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbXIXTLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbXIXTLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759138AbXIXTLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:11:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45658 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756235AbXIXTLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:11:03 -0400
Date: Mon, 24 Sep 2007 12:10:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
Message-Id: <20070924121035.8d8c6ce2.akpm@linux-foundation.org>
In-Reply-To: <20070924175411.GA2314@infradead.org>
References: <20070920195249.852667D5@kernel>
	<20070920195320.38C8E20D@kernel>
	<20070924175411.GA2314@infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 18:54:11 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> As we already say in various messages the percpu counters in here
> look rather fishy.  I'd recomment to take a look at the per-cpu
> superblock counters in XFS as they've been debugged quite well
> now and could probably be lifted into a generic library for this
> kind of think.  The code is mostly in fs/xfs/xfs_mount.c can
> can be spotted by beeing under #ifdef HAVE_PERCPU_SB.
> 
> It also handles cases like hotplug cpu nicely that this code
> seems to work around by always iterating over all possible cpus
> which might not be nice on a dual core laptop with a distro kernel
> that also has to support big iron.

hm.  How come xfs invented a new version of percpu_counters?

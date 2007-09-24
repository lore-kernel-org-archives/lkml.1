Return-Path: <linux-kernel-owner+w=401wt.eu-S1761668AbXIXRyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761668AbXIXRyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbXIXRyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:54:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41225 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbXIXRyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:54:15 -0400
Date: Mon, 24 Sep 2007 18:54:11 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
Message-ID: <20070924175411.GA2314@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070920195249.852667D5@kernel> <20070920195320.38C8E20D@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920195320.38C8E20D@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As we already say in various messages the percpu counters in here
look rather fishy.  I'd recomment to take a look at the per-cpu
superblock counters in XFS as they've been debugged quite well
now and could probably be lifted into a generic library for this
kind of think.  The code is mostly in fs/xfs/xfs_mount.c can
can be spotted by beeing under #ifdef HAVE_PERCPU_SB.

It also handles cases like hotplug cpu nicely that this code
seems to work around by always iterating over all possible cpus
which might not be nice on a dual core laptop with a distro kernel
that also has to support big iron.


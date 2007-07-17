Return-Path: <linux-kernel-owner+w=401wt.eu-S1761077AbXGQHqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077AbXGQHqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbXGQHpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:45:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40509 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbXGQHpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:45:49 -0400
Date: Tue, 17 Jul 2007 08:45:46 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill Kuvaldin <kuvkir@epsmu.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] isofs: mounting to regular file may succeed
Message-ID: <20070717074546.GM21668@ftp.linux.org.uk>
References: <20070713234721.GG4536@zetta.epsmu.com> <20070717000407.4c854ec8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717000407.4c854ec8.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 12:04:07AM -0700, Andrew Morton wrote:

> I don't think any (all?) other filesystems perform checks like this.
> Is this something which can/should be performed at the VFS level?

	I don't see why we _should_ check that; VFS checks that we don't
turn directory into non-directory and vice versa, same as for binding.
There is no reason why fs driver could not give you a single-node filesystem
with root being e.g. a block device node.  You could mount it on any
non-directory and get a block device seen there, etc.

	IOW, if filesystem driver considers fs image it's working from
as invalid, it's up to filesystem driver.  _What_ is considered invalid
depends on fs type; what the driver cares to report as dubious is, again,
up to driver.  If isofs wants to warn about an ISO image that definitely
violates ISO9660, it's isofs decision.  VFS will work with it as long
as fs driver does...

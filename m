Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYFWN4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYFWN4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 09:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYFWNzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 09:55:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51731 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYFWNzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 09:55:51 -0400
Date: Mon, 23 Jun 2008 14:55:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 2/3] vfs: fix sys_getcwd for detached mounts
Message-ID: <20080623135549.GW28946@ZenIV.linux.org.uk>
References: <20080616112804.930095761@szeredi.hu> <20080616112828.731144133@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616112828.731144133@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 01:28:06PM +0200, Miklos Szeredi wrote:

> After the patch it will give a much saner "/skel" result.

I'm not sure that /skel is much saner, to be honest.  Existing
behaviour is BS, no arguments about that, but I suspect that
we want that to be recognizable.  How about doing something
like detached:<rest of path> instead (c.f. "pipe:[6969]" and
its ilk)?

Lack of leading / currently points to pathname *not* resolving
to object; it might be worth doing the same here.  Comments?


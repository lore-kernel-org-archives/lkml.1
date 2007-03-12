Return-Path: <linux-kernel-owner+w=401wt.eu-S965170AbXCLGYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965170AbXCLGYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 02:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965163AbXCLGYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 02:24:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55772 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965153AbXCLGYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 02:24:06 -0400
Date: Mon, 12 Mar 2007 17:23:49 +1100
From: David Chinner <dgc@sgi.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 3/8] per backing_dev dirty and writeback page accounting
Message-ID: <20070312062349.GN6095633@melbourne.sgi.com>
References: <20070306180443.669036741@szeredi.hu> <20070306180550.793803735@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306180550.793803735@szeredi.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 07:04:46PM +0100, Miklos Szeredi wrote:
> From: Andrew Morton <akpm@osdl.org>
> 
> [tomoki.sekiyama.qu@hitachi.com: bugfix]
> 
> Miklos Szeredi <mszeredi@suse.cz>:
> 
> Changes:
>  - updated to apply after clear_page_dirty_for_io() race fix
> 
> This is needed for
> 
>  - balance_dirty_pages() deadlock fix
>  - fuse dirty page accounting
> 
> I have no idea how serious the scalability problems with this are.  If
> they are serious, different solutions can probably be found for the
> above, but this is certainly the simplest.

Atomic operations to a single per-backing device from all CPUs at once?
That's a pretty serious scalability issue and it will cause a major
performance regression for XFS.

I'd call this a showstopper right now - maybe you need to look at
something like the ZVC code that Christoph Lameter wrote, perhaps?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

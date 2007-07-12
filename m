Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbXGLEQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbXGLEQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 00:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbXGLEQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 00:16:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60725 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750970AbXGLEQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 00:16:24 -0400
Date: Thu, 12 Jul 2007 14:16:13 +1000
From: David Chinner <dgc@sgi.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070712041613.GY12413810@sgi.com>
References: <200707111916.35036.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707111916.35036.jesper.juhl@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 07:16:34PM +0200, Jesper Juhl wrote:
> Hi,
> 
> I'm wondering if it's time to make 4K stacks the default and to start 
> considering removing the 8K stack option alltogether soon?
> 
> One of the big problem spots was XFS, but that got some stack usage 
> fixes recently, and the 4K stack option has been around for quite a 
> while now, so people really should have gotten around to fixing any 
> code that can't handle it.   Are there still any big problem areas 
> remaining?

Yes. NFS on top of XFS on top of DM/MD.

XFS got some fixes recently, of which the main one was to fix the
regressions that gcc 4.x introduced by inlining single use functions
that we'd split out of the common code to reduce stack usage. So in
reality, there hasn't been a great deal of change in the status quo
here.

In fact, things have probably got worse because the generic
writeback code is slowly increasing it's stack usage....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbXHBBxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbXHBBxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 21:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbXHBBxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 21:53:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39385 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751542AbXHBBxj (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 21:53:39 -0400
Date: Thu, 2 Aug 2007 11:53:18 +1000
From: David Chinner <dgc@sgi.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: kupdate weirdness
Message-ID: <20070802015318.GM12413810@sgi.com>
References: <E1IGL4G-00088R-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IGL4G-00088R-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 10:45:16PM +0200, Miklos Szeredi wrote:
> The following strange behavior can be observed:
> 
> 1. large file is written
> 2. after 30 seconds, nr_dirty goes down by 1024
> 3. then for some time (< 30 sec) nothing happens (disk idle)
> 4. then nr_dirty again goes down by 1024
> 5. repeat from 3. until whole file is written
> 
> So basically a 4Mbyte chunk of the file is written every 30 seconds.
> I'm quite sure this is not the intended behavior.
> 
> The reason seems to be that __sync_single_inode() will move the
> partially written inode from s_io onto s_dirty, and sync_sb_inode()
> will not splice it back onto s_io until the rest of the inodes on s_io
> has been processed.

It's been doing this for a long time.

http://marc.info/?l=linux-kernel&m=113919849421679&w=2

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

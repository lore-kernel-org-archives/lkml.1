Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbXC0AbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbXC0AbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 20:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbXC0AbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 20:31:01 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55918 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933855AbXC0Aa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 20:30:59 -0400
Date: Tue, 27 Mar 2007 11:30:45 +1100
From: David Chinner <dgc@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, dgc@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
Message-ID: <20070327003045.GV32597093@melbourne.sgi.com>
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu> <20070325153508.10922ebd.akpm@linux-foundation.org> <E1HVkWw-0000yj-00@dorka.pomaz.szeredi.hu> <20070326010124.b4513ce2.akpm@linux-foundation.org> <E1HVlZH-00018f-00@dorka.pomaz.szeredi.hu> <20070326020823.8630bb07.akpm@linux-foundation.org> <1174915828.6792.31.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174915828.6792.31.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 03:30:27PM +0200, Peter Zijlstra wrote:
> On Mon, 2007-03-26 at 02:08 -0800, Andrew Morton wrote:
> > On Mon, 26 Mar 2007 11:32:47 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > > Stopping writers which have idle queues is completely unproductive,
> > > and that is basically what the current algorithm does.
> > 
> > This is because the kernel permits all of its allotment of dirty+writeback
> > pages to be dirty+writeback against a single device.
> > 
> > A good way of solving the one-device-starves-another-one problem is to
> > dynamically adjust the per-device dirty+writeback levels so that (for
> > example) if two devices are being written to, each gets 50% of the
> > allotment.
> 
> This is exactly what happens with my patch if both devices write at the
> same speed. (Or at least, that is what is supposed to happen ;-)

The testing that I did of Peter's patch showed that this cache
splitting works as advertised for multiple devices writing at
the same speed.

(http://marc.info/?l=linux-kernel&m=117437686328396&w=2)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

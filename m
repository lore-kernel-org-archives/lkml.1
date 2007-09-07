Return-Path: <linux-kernel-owner+w=401wt.eu-S932848AbXIGTix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbXIGTix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 15:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbXIGTim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 15:38:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44457 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187AbXIGTil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 15:38:41 -0400
Date: Fri, 7 Sep 2007 20:38:36 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2][RESEND] improve generic_file_buffered_write()
Message-ID: <20070907193836.GB3023@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Bernd Schubert <bs@q-leap.de>, linux-kernel@vger.kernel.org
References: <200709072052.48396.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709072052.48396.bs@q-leap.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 08:52:38PM +0200, Bernd Schubert wrote:
> No further response to our patches yet, so we are sending them again, 
> re-diffed against 2.6.23-rc5
> 
> Hi,
> 
> recently we discovered writing to a nfs-exported lustre filesystem is rather 
> slow (20-40 MB/s writing, but over 200 MB/s reading).
> 
> As I already explained on the nfs mailing list, this happens since there is an 
> offset on the very first page due to the nfs header.
> 
> http://sourceforge.net/mailarchive/forum.php?thread_name=200708312003.30446.bernd-schubert%40gmx.de&forum_name=nfs
> 
> While this especially effects lustre, Olaf Kirch also noticed it on another 
> filesystem before and wrote a nfs patch for it. This patch has two 
> disadvantages  - it requires to move all data within the pages, IMHO rather 
> cpu time consuming, furthermore, it presently causes data corruption when 
> more than one nfs thread is running.
> 
> After thinking it over and over again we (Goswin and I) believe it would be 
> best to improve generic_file_buffered_write().
> If there is sufficient data now, as it is usual for aio writes, 
> generic_file_buffered_write() will now fill each page as much as possible and 
> only then prepare/commit it. Before generic_file_buffered_write() commited 
> chunks of pages even though there were still more data.

While the idea is sound in general the code your touching is almost entirely
gone in -mm and hopefully in 2.6.24.  Can you take a look at the Nick's changes
in -mm that introduce  begin_write and end_write methods replacing prepare_write
and commit_write and see if they improve your situation already.  If not they
should at least provide a framework to deal with it in a slightly cleaner way.


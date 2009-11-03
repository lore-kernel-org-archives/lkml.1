Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZKCOde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZKCOde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZKCOdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:33:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbZKCOdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:33:32 -0500
Date: Tue, 3 Nov 2009 09:33:33 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jan Blunck <jblunck@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 01/27] BKL: Push down BKL from do_new_mount() to the
	filesystems get_sb/fill_super operation
Message-ID: <20091103143333.GA2740@infradead.org>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-2-git-send-email-jblunck@suse.de> <20091102171147.GG21750@bolzano.suse.de> <20091103101212.GA20314@infradead.org> <20091103102509.GL21750@bolzano.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103102509.GL21750@bolzano.suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 11:25:09AM +0100, Jan Blunck wrote:
> > For the next spin please don't push it down to filesystems that
> > obviously don't need it at all and just mention them in the patch
> > description.  For filesystems like xfs and btrfs that never used the BKL
> > at all that should make life a bit simpler.
> 
> My plan was to remove the BKL in the obvious cases in the followup patches
> that are also included in the series. So should I just merge the obvious stuff
> into one patch? Christian Borntraeger was actually requesting the opposite. He
> wants to be able to bisect it to the patch that is removing the BKL. That
> would be much simple with many small patches I think.

Yes, but for most filesystems the BKL never made sense.  Anywhere where
it's non-obvious (or the maintainer wants it) make it a separate patch,
but don't bother for things like xfs or btrfs.


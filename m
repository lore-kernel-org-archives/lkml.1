Return-Path: <linux-kernel-owner+w=401wt.eu-S1751963AbXBFJpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbXBFJpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXBFJpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:45:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54205 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbXBFJpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:45:04 -0500
Date: Tue, 6 Feb 2007 09:44:38 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Christoph Hellwig <hch@lst.de>, akpm@osdl.org, haveblue@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH[RFC] kill sysrq-u (emergency remount r/o)
Message-ID: <20070206094438.GA5328@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Christoph Hellwig <hch@lst.de>, akpm@osdl.org, haveblue@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070205173247.GA25790@lst.de> <Pine.LNX.4.61.0702052136310.19384@yvahk01.tjqt.qr> <20070206031744.GA11018@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206031744.GA11018@thunk.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 10:17:44PM -0500, Theodore Tso wrote:
> > sysrq+u is helpful. It is like \( sysrq+s && make sure no further writes
> > go to disk \).
> 
> I agree it is useful, but if we're going to do it we really should do
> it right.  We should have real revoke() functionality on file
> descriptors, which revokes all of the mmap()'s (any attempt to write
> into a previously read/write mmap will cause a SEGV) as well as
> changing f_mode, and then use that to implement emergency read-only
> remount.

Revoke is only part of it.  What we really need is proper forced unmount
support.  That means revoking any kind of userspace access, blocking new
access and making sure the ondisk image is coherent.  This would definitly
be a useful feature, but it's a lot of work.

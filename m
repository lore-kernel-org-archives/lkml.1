Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbZACVpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbZACVpH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 16:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759927AbZACVos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 16:44:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45745 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034AbZACVor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 16:44:47 -0500
Date: Sat, 3 Jan 2009 16:44:43 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Klotz <peter.klotz@aon.at>, Roman Kononov <kernel@kononov.ftml.net>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: BUG: soft lockup - is this XFS problem?
Message-ID: <20090103214443.GA6612@infradead.org>
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org> <20081230042333.GC27679@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230042333.GC27679@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 05:23:33AM +0100, Nick Piggin wrote:
> On Tue, Dec 23, 2008 at 12:12:59PM -0500, Christoph Hellwig wrote:
> > 
> > Nick, I've seen various reports like this by Roman.  It seems to be
> > caused by an interaction of the lockless pagecache with the xfs
> > I/O code.  Any idea what might be wrong here:
> 
> Hmm, it could get into a loop here if there is a page in the pagecache
> with a zero refcount, which might be a problem with XFS... other looping
> conditions might indicate a problem iwth lockless pagecache or radix
> tree. It would be very helpful to know what condition it is looping on...

See http://oss.sgi.com/bugzilla/show_bug.cgi?id=805

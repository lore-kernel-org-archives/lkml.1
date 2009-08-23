Return-Path: <linux-kernel-owner+w=401wt.eu-S1751009AbZHWWpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009AbZHWWpF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 18:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbZHWWpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 18:45:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbZHWWpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 18:45:04 -0400
Date: Sun, 23 Aug 2009 18:45:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression (& with/2.6.31-rc6)
Message-ID: <20090823224504.GA19942@infradead.org>
References: <alpine.DEB.2.00.0908110624420.22426@p34.internal.lan> <20090816022331.GA2309@infradead.org> <alpine.DEB.2.00.0908171024380.12533@p34.internal.lan> <alpine.DEB.2.00.0908220624440.30321@p34.internal.lan> <20090822142550.GA10003@infradead.org> <alpine.DEB.2.00.0908221044420.30321@p34.internal.lan> <20090822201558.GA17955@infradead.org> <alpine.DEB.2.00.0908221645440.20848@p34.internal.lan> <20090822205502.GA18904@infradead.org> <alpine.DEB.2.00.0908221659030.23463@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908221659030.23463@p34.internal.lan>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, let's see where errors could happen then.

There are four theoretical possibilities:

 (a) XFS
 (b) loop driver
 (c) crypto loop code
 (d) block layer

Or combinations thereof.

I would take (a) and (d) as more unlikely as they tend to get used much
more and I would have heard more bug reports already.

The cryptoloop code hasn't changed at all since 2.6.29.

The loop code howver has a very interesting commit just after 2.6.39:

commit 68db1961bbf4e16c220ccec4a780e966bc1fece3
Author: Nikanth Karthikesan <knikanth@suse.de>
Date:   Tue Mar 24 12:29:54 2009 +0100

    loop: support barrier writes

Can you try reverting this one (it cleanly reverse-applies against
2.6.30 and current mainline) and see if that makes a difference?

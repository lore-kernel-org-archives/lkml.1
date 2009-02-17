Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbZBQLJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbZBQLJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:09:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZBQLIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:08:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52610 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZBQLIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:08:53 -0500
Date: Tue, 17 Feb 2009 06:08:42 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: binfmt_aout fix
Message-ID: <20090217110842.GA22272@infradead.org>
References: <20090217104956.GC25856@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217104956.GC25856@jurassic.park.msu.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 01:49:56PM +0300, Ivan Kokshaysky wrote:
> This fixes the problem introduced by commit 3bfacef412 (get rid of
> special-casing the /sbin/loader on alpha): osf/1 ecoff binary
> segfaults when binfmt_aout built as module. That happens because
> aout binary handler gets on the top of the binfmt list due to late
> registration, and kernel attempts to execute the binary without
> preparation work that must be done by binfmt_loader.

I think the proper fix for this is to make sure newly registered
binfmts are added to the tail of the list, not the front.


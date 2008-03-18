Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYCRHfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYCRHfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 03:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYCRHfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 03:35:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49859 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYCRHfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 03:35:04 -0400
Date: Tue, 18 Mar 2008 03:35:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] de-semaphorize smackfs
Message-ID: <20080318073503.GA25958@infradead.org>
References: <30338.1205795680@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30338.1205795680@vena.lwn.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 05:14:40PM -0600, Jonathan Corbet wrote:
> While looking at the generic semaphore patch, I came to wonder what the
> remaining semaphore users in the kernel were actually doing.  After a
> quick grep for down_interruptible(), smackfs remained at the bottom of
> my screen.  It seems like a straightforward mutex case - low-hanging
> fruit.  So here's a conversion patch; compile-tested only, but what
> could go wrong?

The lock is kept while returning to userspace and could potentially
be release by another process.  This is not allowed for mutexes.


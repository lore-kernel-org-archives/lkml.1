Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYK3NHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYK3NHd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 08:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYK3NHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 08:07:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57690 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYK3NHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 08:07:24 -0500
Date: Sun, 30 Nov 2008 13:07:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kill FMODE_NDELAY_NOW
Message-ID: <20081130130723.GX28946@ZenIV.linux.org.uk>
References: <20081105135842.GB4393@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105135842.GB4393@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 02:58:42PM +0100, Christoph Hellwig wrote:
> Update FMODE_NDELAY before each ioctl call so that we can kill the
> magic FMODE_NDELAY_NOW.  It would be even better to do this directly
> in setfl(), but for that we'd need to have FMODE_NDELAY for all files,
> not just block special files.

We _can't_ do that in setfl() - not unless you such bdev method.
Note that there's a bunch of cases where O_NDELAY at open() is used
to get very different semantics and we want ->release() to see the
matching value.

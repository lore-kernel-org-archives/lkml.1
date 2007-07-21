Return-Path: <linux-kernel-owner+w=401wt.eu-S935813AbXGUGVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935813AbXGUGVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXGUGUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:20:54 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:35350 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbXGUGUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:20:53 -0400
Date: Sat, 21 Jul 2007 15:20:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: werner <werner@copaya.yi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Incompatibilities of kmem_cache_create
Message-ID: <20070721062032.GA1814@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	werner <werner@copaya.yi.org>, linux-kernel@vger.kernel.org
References: <1184997001.28478@werner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184997001.28478@werner>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 02:50:01AM -0300, werner wrote:
> Of the kernel 2.6.22-git15 of this night,  kmem_cache_create is not
> compatible and causes compiling errors of some fundamental programs.
> Before, this error didnt occur.
> 
Slab destructors haven't been supported in the kernel for ages, anything
that's relying on them to work out-of-tree is fundamentally broken.

> At least this happened on compiling the externel modules for btrfs and
> ndiskwrapper.    Principally the compatibility of the Kernel with older
> and new versions of the file systems have to be observed very good, for
> the reliability to can read dates.
> 
> Thus this should be checked, and corrected
> 
Indeed it should. You can correct this by removing the extraneous NULL
parameter for the slab dtor from the kmem_cache_create() callsite in the
out-of-tree code. All of the in-tree users were already converted.

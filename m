Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbXLDKK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbXLDKK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 05:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbXLDKKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 05:10:12 -0500
Received: from ns2.suse.de ([195.135.220.15]:51423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbXLDKKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 05:10:11 -0500
Date: Tue, 4 Dec 2007 11:10:09 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] rewrite rd
Message-ID: <20071204101009.GB9618@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de> <200712041054.51599.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712041054.51599.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 10:54:51AM +0100, Christian Borntraeger wrote:
> Am Dienstag, 4. Dezember 2007 schrieb Nick Piggin:
> [...]
> > There is one slight downside -- direct block device access and filesystem
> > metadata access goes through an extra copy and gets stored in RAM twice.
> > However, this downside is only slight, because the real buffercache of the
> > device is now reclaimable (because we're not playing crazy games with it),
> > so under memory intensive situations, footprint should effectively be the
> > same -- maybe even a slight advantage to the new driver because it can also
> > reclaim buffer heads.
> 
> This is just an idea, I dont know if it is worth the trouble, but have you
> though about implementing direct_access for brd? That would allow 
> execute-in-place (xip) on brd eliminating the extra copy.

Actually that's a pretty good idea. It would allow xip to be tested
without special hardware as well...

I'll see what the patch looks like. Thanks


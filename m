Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752145AbYLRN6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbYLRN6F (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 08:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYLRN5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 08:57:52 -0500
Received: from brick.kernel.dk ([93.163.65.50]:28772 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbYLRN5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 08:57:52 -0500
Date: Thu, 18 Dec 2008 14:57:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mikem@roadking.cca.cpqcorp.net
Subject: Re: [patch] cciss: Fix problem that deleting multiple logical drives could cause a panic
Message-ID: <20081218135720.GR32491@kernel.dk>
References: <20081216201703.GL1126@beardog.cca.cpqcorp.net> <20081216202730.GZ32491@kernel.dk> <20081216204945.GN1126@beardog.cca.cpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216204945.GN1126@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16 2008, scameron@beardog.cca.cpqcorp.net wrote:
> On Tue, Dec 16, 2008 at 09:27:30PM +0100, Jens Axboe wrote:
> > On Tue, Dec 16 2008, scameron@beardog.cca.cpqcorp.net wrote:
> > > 
> > > Fix problem that deleting multiple logical drives could cause a panic.
> > 
> > This looks like a 2.6.28 candidate, correct?
> 
> Yes, and we would like to get it in anywhere else it needs to go
> (backport to 2.6.27.x? if that makes sense.)
> 
> It fixes a panic which can be easily reproduced in the following
> way: Just create several "arrays," each with multiple logical 
> drives via hpacucli, then delete the first array, and it will blow
> up in deregister_disk(), in the call to get_host() when it tries to
> dig the hba pointer out of a NULL queue pointer.
> 
> The problem has been present since my code to make 
> rebuild_lun_table behave better went in.

OK, I'll make sure it goes upstream for 2.6.28. I've merged your other
cciss patch for 2.6.29.

-- 
Jens Axboe


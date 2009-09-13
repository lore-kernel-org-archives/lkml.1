Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbZIMR5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbZIMR5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 13:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbZIMR5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 13:57:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36190 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbZIMR5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 13:57:14 -0400
Date: Sun, 13 Sep 2009 19:57:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: recent bdi changes result in WARN_ON on luksClose / dm
Message-ID: <20090913175717.GO14984@kernel.dk>
References: <20090912111928.GA8013@Chamillionaire.breakpoint.cc> <20090912195212.GF14984@kernel.dk> <20090912195839.GG14984@kernel.dk> <20090913091337.GA21969@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090913091337.GA21969@Chamillionaire.breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 13 2009, Sebastian Andrzej Siewior wrote:
> * Jens Axboe | 2009-09-12 21:58:40 [+0200]:
> 
> >Don't count this as a real fix, I'll investigate closer on monday. Does
> >the warning go away with this hack? It'll ensure that pending dirty
> >inodes are flushed.
> 
> That warning goes away but another pops up:

Oh right, just goes to show that it's doing this backwards. We need the
umount rwsem for WB_SYNC_ALL. I'll look at this tomorrow.

-- 
Jens Axboe


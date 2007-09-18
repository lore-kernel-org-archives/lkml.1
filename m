Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbXIRSjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbXIRSjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbXIRSjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:39:47 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:37475 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbXIRSjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:39:46 -0400
Date: Tue, 18 Sep 2007 19:38:52 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod (v2)
In-Reply-To: <20070918174016.GF18476@fieldses.org>
Message-ID: <Pine.LNX.4.64.0709181935540.14973@blonde.wat.veritas.com>
References: <46EE3724.80200@openvz.org> <1190037331.6700.14.camel@heimdal.trondhjem.org>
 <46EE8C52.80503@openvz.org> <1190044850.6700.81.camel@heimdal.trondhjem.org>
 <46EF7136.7080308@openvz.org> <20070918151957.GA18476@fieldses.org>
 <1190132095.6656.12.camel@heimdal.trondhjem.org> <20070918165220.GE18476@fieldses.org>
 <1190134496.6656.22.camel@heimdal.trondhjem.org> <20070918174016.GF18476@fieldses.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, J. Bruce Fields wrote:
> On Tue, Sep 18, 2007 at 12:54:56PM -0400, Trond Myklebust wrote:
> > 
> > It gets even better when you throw mmap() into the mix :-)
> 
> Hm.  Documentation/mandatory.txt claims that it mandatory locks and
> mmap() with MAP_SHARED exclude each other, but I can't see where that's
> enfoced.  That file doesn't make any mention of the above race.

I believe the locks_verify_locked() call from mm/mmap.c prevents
mmap'ing shared-write a file with mandatory locks in force;
and the mapping_writably_mapped() calls from fs/locks.c prevent
mandatory locking on a file while it's mmap'ed shared-write.

Though I think there's no lock to prevent those checks racing,
so it's not quite watertight.

Hugh

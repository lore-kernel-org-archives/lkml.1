Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbYAJInt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbYAJInt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYAJInj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:43:39 -0500
Received: from brick.kernel.dk ([87.55.233.238]:24987 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbYAJIni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:43:38 -0500
Date: Thu, 10 Jan 2008 09:43:36 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080110084336.GS6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk> <p73k5mjovwg.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73k5mjovwg.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09 2008, Andi Kleen wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> >
> > So how does it work? Instead of punting IO to a thread and passing it
> > through the page cache, we instead attempt to send the IO directly to the
> 
> Great -- something like this was needed for a long time.
> 
> > - The file block mappings must not change while loop is using the file.
> >   This means that we have to ensure exclusive access to the file and
> >   this is the bit that is currently missing in the implementation. It
> >   would be nice if we could just do this via open(), ideas welcome...
> 
> get_write_access()/put_write_access() will block other writers.
> 
> But as pointed out by others that is not enough for this.

Yeah, basically allowing O_RDONLY | O_DIRECT opens should be ok, but we
can't allow writes and we can't allow page cache to exist for this file
outside of loop.

> I suppose you could use a white list like a special flag for file systems 
> (like ext2/ext3) that do not reallocate blocks.

Irk, but yeah we probably need something like that for now until Chris
proposes his API addition.

-- 
Jens Axboe


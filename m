Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYAIPee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYAIPee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYAIPe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:34:26 -0500
Received: from ns2.suse.de ([195.135.220.15]:39775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbYAIPeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:34:25 -0500
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] fast file mapping for loop
From: Andi Kleen <andi@firstfloor.org>
References: <20080109085231.GE6650@kernel.dk>
Date: Wed, 09 Jan 2008 16:34:23 +0100
In-Reply-To: <20080109085231.GE6650@kernel.dk> (Jens Axboe's message of "Wed\, 9 Jan 2008 09\:52\:32 +0100")
Message-ID: <p73k5mjovwg.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:
>
> So how does it work? Instead of punting IO to a thread and passing it
> through the page cache, we instead attempt to send the IO directly to the

Great -- something like this was needed for a long time.

> - The file block mappings must not change while loop is using the file.
>   This means that we have to ensure exclusive access to the file and
>   this is the bit that is currently missing in the implementation. It
>   would be nice if we could just do this via open(), ideas welcome...

get_write_access()/put_write_access() will block other writers.

But as pointed out by others that is not enough for this.

I suppose you could use a white list like a special flag for file systems 
(like ext2/ext3) that do not reallocate blocks.

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbZLWMxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbZLWMxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 07:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbZLWMxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 07:53:37 -0500
Received: from THUNK.ORG ([69.25.196.29]:47285 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbZLWMxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 07:53:36 -0500
Date: Wed, 23 Dec 2009 07:53:34 -0500
From: tytso@mit.edu
To: Julia Lawall <julia@diku.dk>
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] fs/ext4: Eliminate double free
Message-ID: <20091223125334.GE21594@thunk.org>
Mail-Followup-To: tytso@mit.edu, Julia Lawall <julia@diku.dk>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0912201806530.26912@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912201806530.26912@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 06:07:10PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> b_entry_name and buffer are initially NULL, are initialized within a loop
> to the result of calling kmalloc, and are freed at the bottom of this loop.
> The loop contains gotos to cleanup, which also frees b_entry_name and
> buffer.  Some of these gotos are before the reinitializations of
> b_entry_name and buffer.  To maintain the invariant that b_entry_name and
> buffer are NULL at the top of the loop, and thus acceptable arguments to
> kfree, these variables are now set to NULL after the kfrees.
> 
> This seems to be the simplest solution.  A more complicated solution
> would be to introduce more labels in the error handling code at the end of
> the function.

Thanks, added to the ext4 patch queue.

						- Ted

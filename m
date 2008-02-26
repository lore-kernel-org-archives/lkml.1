Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbYBZH7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbYBZH7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbYBZH7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:59:25 -0500
Received: from mail2.shareable.org ([80.68.89.115]:54475 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbYBZH7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:59:24 -0500
Date: Tue, 26 Feb 2008 07:59:21 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20080226075921.GG30238@shareable.org>
References: <20080226072649.GB30238@shareable.org> <20080225234319.f4589ae4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225234319.f4589ae4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 26 Feb 2008 07:26:50 +0000 Jamie Lokier <jamie@shareable.org> wrote:
> 
> > (It would be nicer if sync_file_range()
> > took a vector of ranges for better elevator scheduling, but let's
> > ignore that :-)
> 
> Two passes:
> 
> Pass 1: shove each of the segments into the queue with
>         SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE
> 
> Pass 2: wait for them all to complete and return accumulated result
>         with SYNC_FILE_RANGE_WAIT_AFTER

Thanks.

Seems ok, though being able to cork the I/O until the last one would
be a bonus (like TCP_MORE...  SYNC_FILE_RANGE_MORE?)

I'm imagining I'd omit the SYNC_FILE_RANGE_WAIT_BEFORE.  Is there a
reason why you have it there?  The man page isn't very enlightening.

-- Jamie

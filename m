Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbZIQA4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbZIQA4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbZIQA4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:56:35 -0400
Received: from mail-ew0-f227.google.com ([209.85.219.227]:36599 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZIQA4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:56:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IPLqpecV+tvEURUeY5V6qec/ffm92aWKInch2diiuljIKeHRJSOM+XxQBa7uSNHkl2
         XFw/gsMo1tgMwo71j9sREJD75YePIXxOQfp9u/GgZlWmyEYAyzquk+szFzucY0YmWCIO
         FS2//F/uCZqJ9AUbfP8IQoT4hBbWTJf6uUKC0=
Date: Thu, 17 Sep 2009 02:56:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, hch@infradead.org,
       reiserfs-devel@vger.kernel.org, jeffm@suse.com
Subject: Re: [PATCH] reiserfs: Truncate blocks not used by a write (v2)
Message-ID: <20090917005633.GC8098@nowhere>
References: <1253121912-20718-1-git-send-email-jack@suse.cz> <20090916144815.e544b319.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916144815.e544b319.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 02:48:15PM -0700, Andrew Morton wrote:
> On Wed, 16 Sep 2009 19:25:12 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > It can happen that write does not use all the blocks allocated in write_begin
> > either because of some filesystem error (like ENOSPC) or because page with
> > data to write has been removed from memory. We truncate these blocks so that
> > we don't have dangling blocks beyond i_size.
> 
> This clashes a bit with the kill-the-bkl/reiserfs stuff in linux-next.


Note that the kill-the-bkl/reiserfs tree has suffered from too much
lock inversion problems lately. Even though I just fixed the last one
reported, I would feel more comfortable to schedule this tree for .33
rather than .32

So this tree can be removed from -next and reintegrated once -rc1 is
released, without problem.

So that if this patch is scheduled for .32, I can fix the conflict
myself once -rc1 is released and not burden Stephen with this conflict
which is useless to handle in -next for now.

Thanks.


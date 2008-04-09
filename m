Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbYDIQNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbYDIQNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYDIQN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:13:28 -0400
Received: from mail.fieldses.org ([66.93.2.214]:49489 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbYDIQN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:13:27 -0400
Date: Wed, 9 Apr 2008 12:13:19 -0400
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Adrian Bunk <bunk@kernel.org>, ChristophHellwig <hch@infradead.org>
Subject: Re: [NFS] Use a zero sized array for raw field in struct fid
Message-ID: <20080409161319.GC32475@fieldses.org>
References: <1207561677.3635.166.camel@quoit> <alpine.LFD.1.00.0804070850310.11277@woody.linux-foundation.org> <1207641005.3635.238.camel@quoit> <20080408075807.GA8893@infradead.org> <1207659686.3635.278.camel@quoit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207659686.3635.278.camel@quoit>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 02:01:26PM +0100, Steven Whitehouse wrote:
> >From b8732f8bea4e8abc331b8fa58a4047c91e2e7d02 Mon Sep 17 00:00:00 2001
> From: Steven Whitehouse <swhiteho@redhat.com>
> Date: Tue, 8 Apr 2008 13:12:52 +0100
> Subject: [PATCH] [NFS] Use a zero sized array for raw field in struct fid
> 
> The raw field's size can vary so we use a zero sized array since
> gcc will not allow a variable sized array inside a union. This
> has been tested with ext3 and gfs2 and relates to the bug
> report: http://lkml.org/lkml/2007/10/24/374 and discussion
> thread: http://lkml.org/lkml/2008/4/7/65

OK; queued for 2.6.26.--b.

> 
> Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Neil Brown <neilb@suse.de>
> Cc: J. Bruce Fields <bfields@fieldses.org>
> Cc: Adrian Bunk <bunk@kernel.org>
> 
> diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
> index adcbb05..de8387b 100644
> --- a/include/linux/exportfs.h
> +++ b/include/linux/exportfs.h
> @@ -43,7 +43,7 @@ struct fid {
>  			u32 parent_ino;
>  			u32 parent_gen;
>  		} i32;
> -		__u32 raw[6];
> +		__u32 raw[0];
>  	};
>  };
>  
> -- 
> 1.5.1.2
> 
> 
> 

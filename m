Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZAZKEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZAZKEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 05:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZAZKE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 05:04:29 -0500
Received: from styx.suse.cz ([82.119.242.94]:32776 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750944AbZAZKE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 05:04:28 -0500
Date: Mon, 26 Jan 2009 11:04:27 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/11] quota: Improve locking
Message-ID: <20090126100427.GA2726@duck.suse.cz>
References: <1232129299-22018-1-git-send-email-jack@suse.cz> <1232129299-22018-2-git-send-email-jack@suse.cz> <20090123234912.f78d75a0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123234912.f78d75a0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 23-01-09 23:49:12, Andrew Morton wrote:
> On Fri, 16 Jan 2009 19:08:09 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> >  static DEFINE_SPINLOCK(dq_list_lock);
> > +static DEFINE_SPINLOCK(dq_state_lock);
> >  DEFINE_SPINLOCK(dq_data_lock);
> 
> The chances are very good that two or even three of these locks will
> all get placed into the same cacheline in main memory.  The effects
> will be quite bad if different CPUs (or, worse, different nodes) are
> taking these locks.
>
> For single, kernel-wide locks like these I think we should almost
> always pad out to a cacheline.
  I never thought about this. Thanks for the idea.

> With __cacheline_aligned_in_smp, rather than __cacheline_aligned. 
> Because spinlocks do take space even in uniprocessor builds.
  I've added this to my list of quota cleanups.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

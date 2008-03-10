Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYCJQau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYCJQau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYCJQam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:30:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:37829 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750966AbYCJQam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:30:42 -0400
Date: Mon, 10 Mar 2008 17:30:40 +0100
From: Jan Kara <jack@suse.cz>
To: Josef Bacik <jbacik@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] JBD ordered mode rewrite
Message-ID: <20080310163040.GC30435@duck.suse.cz>
References: <20080306174209.GA14193@duck.suse.cz> <200803061405.03721.jbacik@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803061405.03721.jbacik@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-03-08 14:05:03, Josef Bacik wrote:
> On Thursday 06 March 2008 12:42:09 pm Jan Kara wrote:
> >   Hi,
> >
> >   Below is my rewrite of ordered mode in JBD. Now we don't have a list of
> > data buffers that need syncing on transaction commit but a list of inodes
> > that need writeout during commit. This brings all sorts of advantages such
> > as possibility to get rid of journal heads and buffer heads for data
> > buffers in ordered mode, better ordering of writes on transaction commit,
> > simplification of some JBD code, no more anonymous pages when truncate of
> > data being committed happens. The patch has survived some light testing
> > but it still has some potential of eating your data so beware :) I've run
> > dbench to see whether we didn't decrease performance by different handling
> > of truncate and the throughput I'm getting on my machine is the same (OK,
> > is lower by 0.5%) if I disable the code in truncate waiting for commit to
> > finish... Also the throughput of dbench is about 2% better with my patch
> > than with current JBD.
> >   Any comments or testing most welcome.
> >
> > 									Honza
> 
> Just one nit, doesn't compile properly when jbd/ext3 are modules :).  Thanks 
> much,
  Thanks for spotting this. Will fix :).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

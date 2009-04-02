Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZDBMAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZDBMAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZDBL7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:59:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56610 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbZDBL7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:59:43 -0400
Date: Thu, 2 Apr 2009 07:58:58 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: guard against jiffies wraparound on
 inode->dirtied_when checks (try #3)
Message-ID: <20090402075858.028216c2@barsoom.rdu.redhat.com>
In-Reply-To: <20090401221224.GW11935@one.firstfloor.org>
References: <1238607475-8203-1-git-send-email-jlayton@redhat.com>
	<87y6ukktu9.fsf@basil.nowhere.org>
	<20090401172630.31c6ac7c@tleilax.poochiereds.net>
	<20090401221224.GW11935@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 00:12:24 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> On Wed, Apr 01, 2009 at 05:26:30PM -0400, Jeff Layton wrote:
> > One possibility might be a new debugging option. We could add
> > replacement time_after() and time_before() macros that also check
> > whether the difference in times is beyond a certain threshold
> > (maybe a day or week or so), and pop a printk or otherwise record
> > info about it when one is detected?
> 
> Makes sense. However it might be hard to get people to run kernels
> with heavy debugging options for that long.
> 

Good point. That would limit the usefulness. I also worry that these
macros get used in sensitive places that might not be conducive to
printk's. Plus, we'd have to worry about ratelimiting them since they
could potentially pop often once you did hit the issue.

I'm not sure there's much we can do other than good old-fashioned
review. Identifying places where jiffies-based timestamps might live a
long time is ultimately going to come down to understanding how they're
used in the code.

-- 
Jeff Layton <jlayton@redhat.com>

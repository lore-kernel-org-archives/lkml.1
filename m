Return-Path: <linux-kernel-owner+w=401wt.eu-S934395AbYBHHj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395AbYBHHj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 02:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759047AbYBHHjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 02:39:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:45613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758636AbYBHHjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 02:39:05 -0500
Date: Fri, 8 Feb 2008 08:38:59 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com, arjan@linux.intel.com,
       dgc@sgi.com
Subject: Re: IO queuing and complete affinity with threads (was Re: [PATCH 0/8] IO queuing and complete affinity)
Message-ID: <20080208073859.GE9730@wotan.suse.de>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <20080207182544.GM15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207182544.GM15220@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 07:25:45PM +0100, Jens Axboe wrote:
> Hi,
> 
> Here's a variant using kernel threads only, the nasty arch bits are then
> not needed. Works for me, no performance testing (that's a hint for Alan
> to try and queue up some testing for this variant as well :-)

Well this stuff looks pretty nice (although I'm not sure whether the
softirq->thread changes are a good idea for performance, I guess we'll
see).

You still don't have the option that the Intel patch gave, that is,
to submit on the completer. I guess that you could do it somewhat
generically by having a cpuid in the request queue, and update that
with the completing cpu.

At least they reported it to be the most efficient scheme in their
testing, and Dave thought that migrating completions out to submitters
might be a bottleneck in some cases.


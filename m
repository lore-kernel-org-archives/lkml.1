Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbZFOK31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbZFOK31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760606AbZFOK2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:28:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:16730 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760556AbZFOK2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:28:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,222,1243839600"; 
   d="scan'208";a="154400901"
Date: Mon, 15 Jun 2009 17:56:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 21/22] HWPOISON: send uevent to report memory corruption
Message-ID: <20090615095639.GD6012@localhost>
References: <20090615024520.786814520@intel.com> <20090615031255.278184860@intel.com> <20090615062934.GB31969@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615062934.GB31969@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 02:29:34PM +0800, Andi Kleen wrote:
> On Mon, Jun 15, 2009 at 10:45:41AM +0800, Wu Fengguang wrote:
> > This allows the user space to do some flexible policies.
> > For example, it may either do emergency sync/shutdown
> > or to schedule reboot at some convenient time, depending
> > on the severeness of the corruption.
> > 
> 
> I don't think it's a good idea to export that much detailed information.
> That would become a stable ABI, but might not be possible to keep
> all these details stable. e.g. map count or reference count are
> internal implementation details that shouldn't be exposed.
> And what is an user space application to do with the inode? Run
> find -inum? 

I had plan to export file path too, if available. But you are right,
we should really think twice before exporting them.

> Also we already report the event using low level logging mechanism.
> in a relatively stable form.
> 
> It's also unclear to me what an application would do with that much
> detail.
> 
> I would suggest to drop this part and the earlier flags move.
> 
> Please only bug fixes are this stage.

OK, I'll get rid of the uevent patches numbered 16-21 in the next release.

Thanks,
Fengguang


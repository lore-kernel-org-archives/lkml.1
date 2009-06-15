Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZFOGVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZFOGVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 02:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZFOGV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 02:21:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34439 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZFOGV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 02:21:27 -0400
Date: Mon, 15 Jun 2009 08:29:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 21/22] HWPOISON: send uevent to report memory corruption
Message-ID: <20090615062934.GB31969@one.firstfloor.org>
References: <20090615024520.786814520@intel.com> <20090615031255.278184860@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615031255.278184860@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 10:45:41AM +0800, Wu Fengguang wrote:
> This allows the user space to do some flexible policies.
> For example, it may either do emergency sync/shutdown
> or to schedule reboot at some convenient time, depending
> on the severeness of the corruption.
> 

I don't think it's a good idea to export that much detailed information.
That would become a stable ABI, but might not be possible to keep
all these details stable. e.g. map count or reference count are
internal implementation details that shouldn't be exposed.
And what is an user space application to do with the inode? Run
find -inum? 

Also we already report the event using low level logging mechanism.
in a relatively stable form.

It's also unclear to me what an application would do with that much
detail.

I would suggest to drop this part and the earlier flags move.

Please only bug fixes are this stage.

-Andi

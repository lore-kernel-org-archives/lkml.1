Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbZAFXMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbZAFXMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZAFXLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:11:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbZAFXLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:11:54 -0500
Date: Tue, 6 Jan 2009 15:11:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.29 -mm merge plans
Message-Id: <20090106151131.b6c4ff0b.akpm@linux-foundation.org>
In-Reply-To: <20090106225744.GA10553@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	<20090106225744.GA10553@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc added)

On Tue, 6 Jan 2009 17:57:44 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jan 05, 2009 at 12:43:00AM -0800, Andrew Morton wrote:
> > fs-sys_sync-fix.patch
> 
> I'm not sure this is a good idea.  Concurrent syncs are a bad idea
> to start with and we should just synchronyze do_sync completely.
> sync_filesystems as one of the main components of do_sync already
> is synchronized in that way, and taking that to a higher level would
> get rid of all the worries about concurrent syncs.

Yes, single-threading sys_sync() would fix the problem which that patch
addresses.

However there are a lot of performance and correctness issues around
sys_sync()-versus-fsync(), etc for which such a simple fix won't be
acceptable.


Return-Path: <linux-kernel-owner+w=401wt.eu-S2992913AbXDDO4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992913AbXDDO4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992911AbXDDO4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:56:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992913AbXDDO4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:56:09 -0400
Message-ID: <4613BC5D.2070404@redhat.com>
Date: Wed, 04 Apr 2007 10:55:25 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de> <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com> <20070403202937.GE355@devserv.devel.redhat.com> <20070403144948.fe8eede6.akpm@linux-foundation.org> <20070403160231.33aa862d.akpm@linux-foundation.org> <Pine.LNX.4.64.0704040949050.17341@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0704040949050.17341@blonde.wat.veritas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:

> (I didn't understand how Rik would achieve his point 5, _no_ lock
> contention while repeatedly re-marking these pages, but never mind.)

The CPU marks them accessed&dirty when they are reused.

The VM only moves the reused pages back to the active list
on memory pressure.  This means that when the system is
not under memory pressure, the same page can simply stay
PG_lazyfree for multiple malloc/free rounds.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.

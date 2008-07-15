Return-Path: <linux-kernel-owner+w=401wt.eu-S1762773AbYGOVxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762773AbYGOVxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYGOVxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:53:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095AbYGOVxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:53:38 -0400
Date: Tue, 15 Jul 2008 17:52:52 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com
Subject: Re: [PATCH][RFC] evict streaming IO cache first
Message-ID: <20080715175252.69072c09@cuia.bos.redhat.com>
In-Reply-To: <20080715134848.cf2204b9.akpm@linux-foundation.org>
References: <20080715160948.097b14a4@cuia.bos.redhat.com>
	<20080715134848.cf2204b9.akpm@linux-foundation.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 13:48:48 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 15 Jul 2008 16:09:48 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
> > This patch still needs some testing under various workloads
> > on different hardware - the approach should work but the
> > threshold may need tweaking.
> 
> More than "some"!

Agreed.  In my initial testing this patch seems to bring the
behaviour of the kernel closer to the behaviour the old VM
had, but it certainly needs lots and lots of testing!

> > When there is a lot of streaming IO going on, we do not want
> > to scan or evict pages from the working set.  The old VM used
> > to skip any mapped page, but still evict indirect blocks and
> > other data that is useful to cache.
> 
> I'd be surprised if indirect blocks are getting kicked - they tend to
> be awfully sticky due to frequent touch_buffer()s or equivalent.

If you rewrite a large enough file, they get kicked.  This
has become noticable some time between 2.6.9 and 2.6.18, but
I don't think we can point to any particular changeset that
caused it - and even if we do, chances are it does more good
than harm :)

-- 
All Rights Reversed

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764302AbXHIU4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764302AbXHIU4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbXHIU4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:56:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53937 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755863AbXHIU42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:56:28 -0400
Date: Thu, 9 Aug 2007 13:56:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm1: silly df numbers on 32bit extN
Message-Id: <20070809135614.cf1493b7.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708092108540.10254@blonde.wat.veritas.com>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0708092108540.10254@blonde.wat.veritas.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007 21:17:20 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> On Thu, 9 Aug 2007, Andrew Morton wrote:
> > 
> > +lib-make-percpu_counter_add-take-s64.patch
> 
> lib-make-percpu_counter_add-take-s64.patch looks sensible, but it doesn't
> actually work on 32-bit architectures: several users of percpu_counter_add
> are passing -unsignedlong as the amount, which is not promoted to s64 in
> the desired way, so "df" on extN filesystems is showing silly numbers.
> 
> The hack below (say long instead of s64 or s32) may be good as hotfix for
> 2.6.23-rc2-mm1, but is probably the worst of solutions.  Perhaps take-s64
> should be reverted, perhaps there should be a percpu_counter_sub and the
> filesystems use that instead of saying -unsignedlong, perhaps they should
> use a cast or a long or an s64.  I don't know, but here's this for now...

Thanks.  I think I'll quietly tip the whole patch series overboard and
shoot for a quick rc2-mm2 rather than trying to patch it up in-situ.

I haven't had a chance to review it all in recent months.  Vague first
impressions are that it all goes a bit rampant and changes more than it
needs to, but I'll take a closer look at that if Peter can provide us with
the next version (please).


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYAVSVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYAVSVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 13:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYAVSV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 13:21:26 -0500
Received: from brick.kernel.dk ([87.55.233.238]:23044 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbYAVSV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 13:21:26 -0500
Date: Tue, 22 Jan 2008 19:21:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, knikanth@novell.com
Subject: Re: [PATCH 0/6] IO context sharing
Message-ID: <20080122182121.GX6258@kernel.dk>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com> <1201013372.6341.19.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201013372.6341.19.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22 2008, Peter Zijlstra wrote:
> 
> On Tue, 2008-01-22 at 10:49 +0100, Jens Axboe wrote:
> > Hi,
> > 
> > Today io contexts are per-process and define the (surprise) io context
> > of that process. In some situations it would be handy if several
> > processes share an IO context. With syslets it's especially crucial that
> > the threads working on behalf of the parent process are seen as the same
> > IO context. That goes from both a fairness and performance point of
> > view, since IO schedulers like AS and CFQ base decisions on what the
> > IO context state is. This patchset adds support for processes sharing a
> > single io context and also adds a CLONE_IO flag to denote sharing of
> > IO context.
> 
> Are you planning on extending this to a hierarchical CFQ for cgroups, or
> just giving the IO context to a cgroup?

Not sure what extra extensions it would need on the IO side. As long as
the other side makes sure to group its processes by sharing IO context,
then CFQ will treat that as a single entity.

-- 
Jens Axboe


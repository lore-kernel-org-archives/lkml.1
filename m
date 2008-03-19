Return-Path: <linux-kernel-owner+w=401wt.eu-S934020AbYCTAP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020AbYCTAP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938348AbYCSXda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:33:30 -0400
Received: from phunq.net ([64.81.85.152]:32838 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754663AbYCSXd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:33:28 -0400
From: Daniel Phillips <phillips@phunq.net>
To: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [ANNOUNCE] ddtree: A git kernel tree for storage servers
Date: Wed, 19 Mar 2008 15:33:19 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200803190102.25491.phillips@phunq.net> <170fa0d20803191323o65bd9738j80511de2c9f6a03c@mail.gmail.com>
In-Reply-To: <170fa0d20803191323o65bd9738j80511de2c9f6a03c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803191633.20922.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 March 2008 13:23, Mike Snitzer wrote:
> >   * Block layer deadlock fixes (Status: production)
> 
> Do you happen to have a pointer to where these block layer deadlock
> fixes are?  Or will you be committing them shortly?

Hi Mike,

OK, this is committed now, but caveat: improved, untested except for
booting.  But what could possibly go wrong? :-/

http://phunq.net/ddtree?p=ddtree/.git;a=blob;f=patches/bio-throttle

The production version is sitting in the code.google.com svn repository
in ddsnap/patches/2.6.23.8.  That one has a known bug that has somehow
escaped being stomped with a new commit, since it only manifests if you
stack one stacking block device on top of another one.  I will post here
when we have an official, torture tested version of the patch.

The patch above is improved from the most recently posted version by
using using the ->bi_max_vecs field for throttle accounting instead of
calling out to a per-driver metric.  This works nicely because the
max_vecs field cannot change during the life of the bio, and it gives
a decent upper bound on the resource consumption of the bio, better
than simply counting bios in flight.  The queue->metric() method is
still in there as a stub, some more cleanup to do there (and further
shrinking of the patch).  It does no harm.

This improvement shrinks the throttled version of struct bio by 4
bytes.

Regards,

Daniel

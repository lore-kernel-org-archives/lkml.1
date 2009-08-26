Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbZHZNkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbZHZNkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbZHZNkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:40:46 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:39990 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292AbZHZNkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:40:46 -0400
Date: Wed, 26 Aug 2009 08:40:45 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] document flash/RAID dangers
Message-ID: <20090826134045.GA1516467@hiwaay.net>
References: <dddMw-7Xt-57@gated-at.bofh.it> <dddWc-83W-51@gated-at.bofh.it> <ddefx-5R-37@gated-at.bofh.it> <ddep7-bI-7@gated-at.bofh.it> <ddeyR-iy-11@gated-at.bofh.it> <ddeyR-iy-9@gated-at.bofh.it> <ddeIu-n9-9@gated-at.bofh.it> <ddeSb-th-29@gated-at.bofh.it> <ddoRI-11a-39@gated-at.bofh.it> <ddpkB-1jQ-1@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826124058.GK32712@mit.edu>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Theodore Tso  <tytso@mit.edu> said:
>Well, the softwar raid layer could be improved so that it implements
>scrubbing by default (i.e., have the md package install a cron job to
>implement a periodict scrub pass automatically).

Fedora 11 added a cron job to kick off a RAID check for each Linux MD
RAID array every week.  Combined with running mdmonitor, root will get
an email on any failure.

The other thing about this thread is that the only RAID implementation
that is being discussed here is the MD RAID stack.  There are a lot of
RAID implementations that have the same issues:

- motherboard (aka "fake") RAID - In Linux this is typically mapped with
  device mapper via dmraid; AFAIK there is not a tool to scrub (or even
  monitor the status of and notify on failure) a Linux DM RAID setup.

- hardware RAID cards without battery backup - these have the exact same
  issues because they cannot guarantee all writes complete, nor can they
  keep track of incomplete writes across power failures

- hardware RAID cards _with_ battery backup but that don't periodically
  test the battery and have a way to notify you of battery failure while
  Linux is running

The issues being raised here are not specific to extX, MD RAID, or Linux
at all; they are problems with non-"enterprise-class" RAID setups.
There's a reason enterprise-class RAID costs a lot more money than the
card you can pick up at Fry's.

There's no reason to document the design issues of general RAID
implementations in the Linux kernel.
-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.

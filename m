Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbXJ2TgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbXJ2TgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbXJ2TgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:36:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52691 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751415AbXJ2TgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:36:04 -0400
Date: Mon, 29 Oct 2007 12:35:58 -0700
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: rientjes@google.com, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071029123558.fb077ca9.pj@sgi.com>
In-Reply-To: <1193674988.5035.93.camel@localhost>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	<alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<1193411888.5032.9.camel@localhost>
	<alpine.DEB.0.9999.0710261136500.11674@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710271212450.19199@chino.kir.corp.google.com>
	<1193674988.5035.93.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> 2.  As this thread progresses, you've discussed relaxing the requirement
> that applications pass a valid subset of mems_allowed.  I.e., something
> that was illegal becomes legal.  An API change, I think.  But, a
> backward compatible one, so that's OK, right? :-)

The more I have stared at this, the more certain I've become that we
need to make the mbind/mempolicy calls modal -- the default mode
continues to interpret node numbers and masks just as these calls do
now, and the alternative mode provides the so called "Choice B",
which takes node numbers and masks as if the task owned the entire
system, and then the kernel internally and automatically scrunches
those masks down to whatever happens to be the current cpuset of
the task.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

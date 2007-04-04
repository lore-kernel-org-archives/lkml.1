Return-Path: <linux-kernel-owner+w=401wt.eu-S2992536AbXDDCzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992536AbXDDCzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992532AbXDDCzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:55:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47410 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992536AbXDDCzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:55:41 -0400
Date: Tue, 3 Apr 2007 19:55:38 -0700
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: drepper@redhat.com, linux-kernel@vger.kernel.org, ego@in.ibm.com,
       dipankar@in.ibm.com, mingo@elte.hu, oleg@tv-sign.ru
Subject: Re: getting processor numbers
Message-Id: <20070403195538.c3419684.pj@sgi.com>
In-Reply-To: <20070403162349.583adf84.akpm@linux-foundation.org>
References: <461286D6.2040407@redhat.com>
	<20070403131623.c6831607.akpm@linux-foundation.org>
	<4612BB89.8040102@redhat.com>
	<20070403141348.9bcdb13e.akpm@linux-foundation.org>
	<4612D175.30604@redhat.com>
	<20070403154831.37bde672.akpm@linux-foundation.org>
	<4612DCA2.2090400@redhat.com>
	<20070403162349.583adf84.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> > But all this of course does not solve the issue sysconf() has.  In
> > sysconf we cannot use sched_getaffinity since all the systems CPUs must
> > be reported.
> 
> OK.
> 
> This is excecptionally gruesome, but one could run sched_getaffinity()
> against pid 1 (init).  Which will break nicely in the OS-virtualised future
> when the system has multiple pid-1-inits running in containers...

That nicely breaks on typical cpuset managed systems as well, which
frequently put init into a small cpuset (with the classic Unix daemon
and login load), leaving the bulk of the system to be managed by a
batch scheduler.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

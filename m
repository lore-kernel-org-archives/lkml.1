Return-Path: <linux-kernel-owner+w=401wt.eu-S2992449AbXDDC6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992449AbXDDC6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992533AbXDDC6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:58:50 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49675 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992449AbXDDC6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:58:49 -0400
Date: Tue, 3 Apr 2007 19:58:46 -0700
From: Paul Jackson <pj@sgi.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ego@in.ibm.com,
       dipankar@in.ibm.com
Subject: Re: getting processor numbers
Message-Id: <20070403195846.d03fe3ec.pj@sgi.com>
In-Reply-To: <4612DCA2.2090400@redhat.com>
References: <461286D6.2040407@redhat.com>
	<20070403131623.c6831607.akpm@linux-foundation.org>
	<4612BB89.8040102@redhat.com>
	<20070403141348.9bcdb13e.akpm@linux-foundation.org>
	<4612D175.30604@redhat.com>
	<20070403154831.37bde672.akpm@linux-foundation.org>
	<4612DCA2.2090400@redhat.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich wrote:
> But all this of course does not solve the issue sysconf() has.  In
> sysconf we cannot use sched_getaffinity since all the systems CPUs must
> be reported.

Good point.  Yes, sysconf(_SC_NPROCESSORS_CONF) really needs to continue
returning the number of CPUs online, to maintain compatibility with the
current implementation, and because with a name like that, just about
anything else would be "surprising".

And OpenMPI shouldn't be calling sysconf(_SC_NPROCESSORS_CONF), as it does
not want to know how much hardware is there, but rather how much hardware
it is allowed to use.  Something based on sched_getaffinity() would seem
to be ideal for its purposes.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

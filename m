Return-Path: <linux-kernel-owner+w=401wt.eu-S2992648AbXEBDWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992648AbXEBDWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 23:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992654AbXEBDWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 23:22:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52424 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992648AbXEBDWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 23:22:03 -0400
Date: Tue, 1 May 2007 20:22:01 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: torvalds@linux-foundation.org, menage@google.com,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: allow empty {cpus,mems}_allowed to be set for
 unpopulated cpuset
Message-Id: <20070501202201.6903d922.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705011714490.6376@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705011714490.6376@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> You currently cannot remove all cpus or mems from cpus_allowed or
> mems_allowed of a cpuset.  We now allow both if there are no attached
> tasks.

Why do you need this?  It adds a little more code, and changes
semantics a little bit, so I'd think it should have at least a
little bit of justfication.


+	if (!*buf) {
+		cpus_clear(trialcs.cpus_allowed);

Won't the above code fail if someone does:

	echo > /dev/cpuset/foobar/mems

Just guessing, but I'd expect buf[] to contain a newline char,
not just a zero length string, at this point.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

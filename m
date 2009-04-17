Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbZDQBmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbZDQBmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbZDQBmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:42:12 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:44016 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073AbZDQBmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:42:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiAFAAB450lMQW1W/2dsb2JhbACBTs5ag30G
Date: Thu, 16 Apr 2009 21:42:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 2/3] RCU move trace defines to rcupdate_types.h
Message-ID: <20090417014209.GA24956@Krystal>
References: <20090417003755.276959950@polymtl.ca> <20090417003931.846405986@polymtl.ca> <49E7D701.9090407@goop.org> <alpine.DEB.2.00.0904162122250.20429@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904162122250.20429@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:39:53 up 47 days, 22:06,  1 user,  load average: 0.43, 0.36,
	0.37
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Thu, 16 Apr 2009, Jeremy Fitzhardinge wrote:
> 
> > I don't think this helps.  rcupdate_types.h uses preempt_disable/enable, but
> > doesn't include linux/preempt.h for them - but someone's going to have to, so
> > you've got an implicit dependency on the user to #include the right headers in
> > advance.
> 
> Would including linux/preempt.h in rcupdate_types.h be a problem?
> 
> -- Steve
> 

I did not include preempt.h in rcupdate_types.h because rcupdate.h did
not include it, so I thought it had a special status such a kernel.h.
However, I notice the rcupdate.h includes spinlock.h, which in turn
includes preempt.h, so we would need to include preempt.h in
rcupdate_types.h.

But I think preempt.h is pretty much only type definitions. I don't
think that would be a problem, but maybe Jeremy knows better.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

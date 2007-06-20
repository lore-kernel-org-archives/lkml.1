Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbXFTB7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbXFTB7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 21:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbXFTB7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 21:59:05 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:34446 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758123AbXFTB7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 21:59:04 -0400
Date: Tue, 19 Jun 2007 21:49:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mbligh@google.com
Subject: Re: Problem with global_flush_tlb() on i386 in 2.6.22-rc4-mm2
Message-ID: <20070620014924.GA19080@Krystal>
References: <20070619170914.GA30623@Krystal> <46788188.1040403@codemonkey.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46788188.1040403@codemonkey.ws>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:46:17 up 22 days, 10:24,  2 users,  load average: 0.74, 0.53, 0.55
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Anthony Liguori (anthony@codemonkey.ws) wrote:
 
> This is actually very conservative seeing as how disabling CR4.PGE 
> should be sufficient to flush global pages on modern processors.  I 
> suspect you're getting preempted while it's running.
> 

Sorry, I just realized that I rejected your preemption explanation
without explaining why:

1 - In my "Text Section" lock code, which is the original place where I
triggered the problem, I take a spinlock around these operations, which
disables preemption.

2 - My sample module plays alone in its own data structures: there is
only one thread accessing the data at a given time (because I do only
one file open at a given time, which I control).

Regards,

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

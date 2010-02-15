Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab0BOTre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:47:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287Ab0BOTrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:47:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Michael Stefaniuc <mstefani@redhat.com>
X-Fcc: ~/Mail/linus
Cc: prasad@linux.vnet.ibm.com, Frederic Weisbecker <fweisbec@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
In-Reply-To: Michael Stefaniuc's message of  Monday, 15 February 2010 20:37:31 +0100 <4B79A27B.6080607@redhat.com>
References: <4B743149.4000707@redhat.com>
	<20100211182224.GC4915@nowhere>
	<4B745F5C.5050001@redhat.com>
	<20100213173323.GB3778@in.ibm.com>
	<4B7719AC.6040901@redhat.com>
	<20100214171535.GA5065@nowhere>
	<4B785952.8020706@redhat.com>
	<20100214204130.GD5479@nowhere>
	<4B7881AC.5070209@redhat.com>
	<20100215115713.GA8907@in.ibm.com>
	<4B79A27B.6080607@redhat.com>
X-Zippy-Says: I predict that by 1993 everyone will live in and around LAS VEGAS
    and wear BEATLE HAIRCUTS!
Message-Id: <20100215194724.8B5F519@magilla.sf.frob.com>
Date: Mon, 15 Feb 2010 11:47:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - The other one with 'locally'/'globally' enabled breakpoints.

There is no "local/global" enablement.  That distinction is meaningless
given the way the kernel uses the hardware.  Which of those bits you set
has no material effect on the watchpoint/trap behavior.  

The only regression is in the observed bit pattern read back from dr7.
To be 100% compatible, the hw_breakpoint ptrace-compatibility front-end
should record the state of the useless bits to report back, so the only
differences from the bit pattern written are whatever ones the real
hardware would have shown from writing dr7 and reading it back.


Thanks,
Roland
 

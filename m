Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260Ab0A0LFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0A0LFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187Ab0A0LFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:05:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679Ab0A0LFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:05:35 -0500
Date: Wed, 27 Jan 2010 03:04:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Tom Tromey <tromey@redhat.com>, Kyle Moffett <kyle@moffetthome.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, JimKeniston <jkenisto@us.ibm.com>
Subject: Re: linux-next: add utrace tree
In-Reply-To: <1264589716.4283.2006.camel@laptop>
Message-ID: <alpine.LFD.2.00.1001270302200.24253@localhost.localdomain>
References: <20100121013822.28781960.sfr@canb.auug.org.au>  <20100122005147.GD22003@redhat.com>  <20100121170541.7425ff10.akpm@linux-foundation.org>  <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>  <20100122182827.GA13185@redhat.com>
 <20100122200129.GG22003@redhat.com>  <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>  <20100122221348.GA4263@redhat.com>  <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>  <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> 
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>  <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>  <m33a1tnbd9.fsf@fleche.redhat.com>  <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>  <m3636oh2rt.fsf@fleche.redhat.com> 
 <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>  <1264575134.4283.1983.camel@laptop>  <alpine.LFD.2.00.1001270231520.24253@localhost.localdomain> <1264589716.4283.2006.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jan 2010, Peter Zijlstra wrote:
> 
> Right, so there's two aspects:
> 
>  1) concurrency when inserting the probe

That's the one I worried about. Stopping all threads will fix it, 
obviously at a disastrous performance cost, but what do I care? As noted, 
there are ways to do it safely with TLB switching, so it's fixable.

>  2) concurrency when hitting the probe

Yeah, I didn't worry about this part, since the only solution is the 
out-of-line one, and I don't much care how the memory gets allocated for 
it. Inserting a whole new vma seems pretty drastic, but compared to 
stopping all threads, it's a small thing.

		Linus

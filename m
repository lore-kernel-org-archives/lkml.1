Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbZBZSah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbZBZSah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZBZSa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:30:27 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:36113 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZBZSa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:30:26 -0500
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
 do?
From: Greg Kurz <gkurz@fr.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, mpm@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de, xemul@openvz.org
In-Reply-To: <20090226173302.GB29439@elte.hu>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
	 <1234285547.30155.6.camel@nimitz>
	 <20090211141434.dfa1d079.akpm@linux-foundation.org>
	 <1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx>
	 <20090212114207.e1c2de82.akpm@linux-foundation.org>
	 <1234475483.30155.194.camel@nimitz>
	 <20090212141014.2cd3d54d.akpm@linux-foundation.org>
	 <1234479845.30155.220.camel@nimitz>
	 <20090226162755.GB1456@x200.localdomain>  <20090226173302.GB29439@elte.hu>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 19:30:16 +0100
Message-Id: <1235673016.5877.62.camel@bahia>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 18:33 +0100, Ingo Molnar wrote:
> I think the main question is: will we ever find ourselves in the 
> future saying that "C/R sucks, nobody but a small minority uses 
> it, wish we had never merged it"? I think the likelyhood of that 
> is very low. I think the current OpenVZ stuff already looks very 

We've been maintaining for some years now a C/R middleware with only a
few hooks in the kernel. Our strategy is to leverage existing kernel
paths as they do most of the work right.

Most of the checkpoint is performed from userspace, using regular
syscalls in a signal handler or /proc parsing. Restart is a bit trickier
and needs some kernel support to bypass syscall checks and enforce a
specific id for a resource. At the end, we support C/R and live
migration of networking apps (websphere application server for example).

>From our experience, we can tell:

Pros: mostly not-so-tricky userland code, independent from kernel
internals
Cons: sub-optimal for some resources

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.


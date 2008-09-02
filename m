Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbYIBNoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbYIBNoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYIBNn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:43:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:59687 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbYIBNn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:43:56 -0400
Date: Tue, 2 Sep 2008 06:43:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "CHADHA,VINEET" <vineet@ufl.edu>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org, vineet@ufl.edu
Subject: Re: TLB evaluation for Linux
Message-ID: <20080902064353.09cf4a48@infradead.org>
In-Reply-To: <1942732773.182121220328723728.JavaMail.osg@osgjas04.cns.ufl.edu>
References: <1942732773.182121220328723728.JavaMail.osg@osgjas04.cns.ufl.edu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008 00:12:03 -0400 (EDT)
"CHADHA,VINEET" <vineet@ufl.edu> wrote:

> Hi,
> 
> I have been working to evaluate TLB performance for Linux O/S and 
> virtualized workloads(such as Xen) in a Full system simulator(e.g. 
> simics). While my evaluation is in nascent stage, I do notice that 
> most of the IPIs in multi-core environments cause complete TLB 
> Flush.

note that linux only does an ipi to processors that actually are
currently running a thread of the same program (or a kernel thread).
Old versions didn't do this (they also IPI'd idle processors), but
on modern cpus and modern kernels that's not supposed to happen anymore
(the C-states that flush the tlb anyway now do the kernel side
bookkeeping as well to avoid the wakeup+useless flush)
> 
> I want to evaluate cost of TLB shootdown including re-population 
> vs. each entry shootdown (invlpg). While a similar study has been 
> done in other kernels (e.g. L4 kernel), I am not aware if it has 
> been done for Linux O/S.
> 

one of the problems is that invlpg is rather expensive; in long-ago
experiments the threshold was like around a handful of pages already.
At that point.. all the bookkeeping isn't likely to be a win.
Esp since a tlb refill on x86 is quite cheap. 

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

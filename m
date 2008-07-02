Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYGBVDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYGBVDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYGBVDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:03:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:40138 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbYGBVDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:03:09 -0400
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
In-Reply-To: <20080702200047.GA385@goodmis.org>
References: <1214916335.20711.141.camel@pasglop>
	 <486B0298.5030508@linux.intel.com> <1214977447.21182.33.camel@pasglop>
	 <1215007896.3330.6.camel@localhost.localdomain>
	 <20080702200047.GA385@goodmis.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 07:02:53 +1000
Message-Id: <1215032573.21182.59.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 16:00 -0400, Steven Rostedt wrote:
> 
> As for interrupt threads, those would help for some non-RT issues
> (having a better desktop feel) but not for the issue that Ben has been
> stating. I would be interested in knowing exactly what is needing to
> handle a page fault inside the kernel.  If we need to do something for a
> user space task, as soon as that task is found the work should be passed
> to that thread.

Not much is needed, as the mm is passed as an argument to
handle_mm_fault(). Page faults can already be handled by 'other'
processes (get_user_pages() doesn't have to be called in the context of
the target mm). I need to check if we may not get into funky issues down
at the vfs level if using a kernel thread without files and I may need
to dbl check if anything in that path tries to signal but that's about
it afaik.

Ben.



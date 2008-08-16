Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbYHPWbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbYHPWbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 18:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbYHPWbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 18:31:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:40818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYHPWbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 18:31:36 -0400
Date: Sat, 16 Aug 2008 15:31:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC 3/3] x86: use mwait for trigger API
Message-ID: <20080816153109.3469878c@infradead.org>
In-Reply-To: <48A74BAA.4010908@goop.org>
References: <48A70192.7020002@goop.org>
	<20080816104404.070e0c14@infradead.org>
	<48A74BAA.4010908@goop.org>
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

On Sat, 16 Aug 2008 14:50:34 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Arjan van de Ven wrote:
> > monitor/mwait is rather really expensive.. are we really sure we
> > want to use this?
> > (from an Intel cpu perspective the answer is very likely no; but I
> > don't know what AMD does here)
> >   
> 
> The intended use is when you're going to be waiting for a while (on
> the order of microseconds or more). 

well mwait really is not cheap, I'd not be surprised if it's in that
same order.

> In the Xen case, I use this to
> block the vcpu if we pass a few iterations without the condition
> being true. While the mwait patch doesn't do this at present, it
> could.

that's another hard one.. passing C-state hints into mwait needs ACPI
help; the BIOS tells us which mwait values are legal/valid at any point
in time.. but this gets tricky to put into these spinpletions.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

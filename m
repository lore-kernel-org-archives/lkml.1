Return-Path: <linux-kernel-owner+w=401wt.eu-S932870AbXHHOHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbXHHOHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbXHHOHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:07:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbXHHOHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:07:18 -0400
Date: Wed, 8 Aug 2007 10:06:13 -0400 (EDT)
From: Chip Coldwell <coldwell@redhat.com>
To: Vivek Goyal <vgoyal@in.ibm.com>
cc: Martin Wilck <martin.wilck@fujitsu-siemens.com>,
       Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
In-Reply-To: <20070808103603.GC13808@in.ibm.com>
Message-ID: <Pine.LNX.4.64.0708081003000.29193@bogart.boston.redhat.com>
References: <46B73955.2080007@fujitsu-siemens.com> <20070807142928.GA18839@in.ibm.com>
 <46B8AECA.7050908@fujitsu-siemens.com> <20070808103603.GC13808@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Vivek Goyal wrote:

> On Tue, Aug 07, 2007 at 07:41:30PM +0200, Martin Wilck wrote:
> > 
> > Can you explain how, on the front side bus, the IO-APIC knows whether
> > a CPU has accepted the INT message? There is no response
> > to the INT message on the bus, except for the EOI which comes much later.
> > I'm not saying that you're wrong, I just really don't understand this
> > point.
> > 
> 
> I don't know what is exactly hardware protocol. I am just going by 
> intel documentation. 

I think it's important to distinguish between the LAPIC receiving an
interrupt and the CPU receiving an interrupt.  The former could happen
without the latter if the CPU has set the TPR above the priority of
the interrupt received by the LAPIC.  In that case, the interrupt is
kept pending in the LAPIC and recorded in the IRR if I understand the
Intel documentation correctly.

So I think the scenario which leaves IRR set when the kdump kernel
starts is possible.

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc
978-392-2426


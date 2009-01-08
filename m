Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbZAIGZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbZAIGZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZAIGZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:25:24 -0500
Received: from dsl081-166-245.sea1.dsl.speakeasy.net ([64.81.166.245]:36961
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752760AbZAIGZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:25:24 -0500
X-Greylist: delayed 3594 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2009 01:25:23 EST
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: amd5536udc interrupts bug
Date: Wed, 7 Jan 2009 19:30:02 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: thomas.dahlmann@amd.com, linux-kernel@vger.kernel.org
References: <200901071510.00673.vlobanov@speakeasy.net> <496565D9.6040102@shaw.ca>
In-Reply-To: <496565D9.6040102@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901071930.03240.vlobanov@speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2009 18:32:57 Robert Hancock wrote:
> Vadim Lobanov wrote:
> > The simple fix may be to say that amd5536udc does not support shared
> > irqs, and to remove the IRQF_SHARED flag from the request_irq() call. A
>
> That will bust any other hardware that tries to share the interrupt. If
> a driver requests the interrupt without IRQF_SHARED, nothing else can
> request that interrupt line.

Of course.

And I do still need to check what other bits and pieces of hardware, if any, 
may want to make use of that particular interrupt. Given that I'm trying to 
get this to run on a very specific system (a Hurricane LX-800), the simple 
solution may very well work locally.

In fact, it may even be a good first problem-solving step for the vanilla 
kernel, if only to quickly mark the driver as "known bad with shared irqs" to 
possibly save someone else from having to perform a debugging session. The 
full fix can then happen later.

> > more complicated fix may be to try to shuffle all the code around to
> > make sure that 'dev' is fully initialized before we request the irq, but
> > I don't understand the code well enough (yet) to comfortably do this.
>
> Yeah, that's the proper fix.
>
> > On a side note, it occurs to me that the CONFIG_DEBUG_SHIRQ option
> > went into the kernel a bit less than two years ago, and that it exposes a
> > very immediate and reproducible OOPS in this driver. Does this mean
> > that noone uses the 5536 UDC functionality with any recent kernels?
> > Should I be worried? :)
>
> Presumably nobody uses it with CONFIG_DEBUG_SHIRQ, that option wouldn't
> normally be used on non-debug kernels..

Which does nicely illustrate the value of running a debugging-enabled kernel 
during development. Random OOPSen out in the field == ouch. Much pain was saved 
this time around.

-- Vadim Lobanov


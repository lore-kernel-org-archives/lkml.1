Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbZBSSjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbZBSSjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZBSSin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:38:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43615 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbZBSSim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:38:42 -0500
To: Ian Jackson <Ian.Jackson@eu.citrix.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "xen-devel\@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Anders Kaseorg <andersk@MIT.EDU>
Subject: Re: [Xen-devel] Re: [PATCH] IRQ handling race and spurious IIR read in serial/8250.c
References: <1233800599.5398.0.camel@balanced-tree>
	<18827.7191.646173.99255@mariner.uk.xensource.com>
	<1233862446.5676.28.camel@balanced-tree>
	<1233870772.5676.40.camel@balanced-tree>
	<18833.40557.119090.48930@mariner.uk.xensource.com>
	<alpine.DEB.2.00.0902101249181.20723@vinegar-pot.mit.edu>
	<18834.63479.700909.321686@mariner.uk.xensource.com>
	<18845.40059.190188.291643@mariner.uk.xensource.com>
From: Markus Armbruster <armbru@redhat.com>
Date: Thu, 19 Feb 2009 19:37:53 +0100
In-Reply-To: <18845.40059.190188.291643@mariner.uk.xensource.com> (Ian Jackson's message of "Thu\, 19 Feb 2009 17\:52\:59 +0000")
Message-ID: <87vdr6z30e.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Jackson <Ian.Jackson@eu.citrix.com> writes:

> I wrote:
>> In drivers/serial/8250.c in Linux there are two bugs:
>>  1. UART_BUG_TXEN can be spuriously set, due to an IRQ race
>>  2. The workaround then applied by the kernel is itself buggy
>
> Markus Armbruster has also experienced this problem in a Xen
> environment and has confirmed that my patch fixes it.

Correct.

> I think at the very least this change:
>
>> Proposed initial band-aid fix (against 2.6.28.4):
>> 
>> Do not read IIR in serial8250_start_tx when UART_BUG_TXEN
>> 
>> Reading the IIR clears some oustanding interrupts so it is not safe.
>> Instead, simply transmit immediately if the buffer is empty without
>> regard to IIR.
>> 
>> Signed-off-by: Ian Jackson <ian.jackson@eu.citrix.com>
>
> should be made right away.
>
> Ian.

Patch makes sense to me.

Acked-by: Markus Armbruster <armbru@redhat.com>

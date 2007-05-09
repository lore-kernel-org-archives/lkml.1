Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbXEIXoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbXEIXoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760691AbXEIXn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:43:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760685AbXEIXny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:43:54 -0400
Message-ID: <46425BF0.8070401@redhat.com>
Date: Wed, 09 May 2007 19:40:32 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 4/6] firewire: OHCI-1394 lowlevel driver
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de> <20070504111125.GA3028@infradead.org>
In-Reply-To: <20070504111125.GA3028@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>> +	if (pci_enable_device(dev)) {
>> +		fw_error("Failed to enable OHCI hardware.\n");
>> +		return cleanup(ohci, CLEANUP_PUT_CARD, -ENODEV);
> 
> Please use normal goto unwinding so the driver follows the same model
> as almost all other pci drivers and allows people to follow your driver
> more easily.  Also it's not a alot of cleanup code, so removing this
> might actually be a net decrease in lines of code.

Sure.  The patch I have here says 42 insertions, 44 deletions :)

>> +	if (software_reset(ohci)) {
> 
> Please give all your function a nice prefix so that oops messages are
> more readable.

I don't see a strong precedence for this for static functions.  For example, 
if you grep for 'static' in drivers/usb/core, there's a mix of usb_* prefixed 
functions and functions without a consistent prefix.  Plus, when the drivers 
are loaded as modules, the module name will be in the stack trace.  I can 
track down the most generic sounding functions and give them a fw_ prefix, but 
doing a whole-sale prefixing of static functions will make the source more 
noisy and reduce readabilty - I'm not sure it's worth it.

cheers,
Kristian

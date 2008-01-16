Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYAPXhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYAPXhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYAPXhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:37:38 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:50016 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbYAPXhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:37:37 -0500
Message-ID: <478E946D.9040105@keyaccess.nl>
Date: Thu, 17 Jan 2008 00:34:05 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: 7eggert@gmx.de, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Russell King <rmk+serial@arm.linux.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 2/2] 8250_pnp: register x86 COM ports at the conventional
 ttyS names
References: <9MjWa-VI-9@gated-at.bofh.it> <9MjWb-VI-11@gated-at.bofh.it> <9MlEG-3Mx-13@gated-at.bofh.it> <9Mmra-56f-29@gated-at.bofh.it> <E1JFEwb-0000zs-2q@be1.7eggert.dyndns.org> <478E6C20.2030005@zytor.com>
In-Reply-To: <478E6C20.2030005@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-01-08 21:42, H. Peter Anvin wrote:

> Bodo Eggert wrote:
>> 
>> BTW1: These addresses may be used to detect ports on non-standard 
>> addresses, but unfortunately they don't tell the IRQ.
>> 
>> BTW2: When I submitted a patch using the BIOS data area, I was told 
>> that it might not exist on systems booting from non-PC firmware. This 
>> claim was not yet backed with any knowledge, nor did anybody suggest a 
>> way to detect this situation.
> 
> This is, of course, true.  It doesn't exactly help that some (most?) 
> non-PC firmware at least mimic the BIOS data area.
> 
> In this particular case, there is some minor sanity-checking that can be
> done: the values should be nonzero and aligned 8.

The number of places expected to contain something sensible should I believe 
first be verified at 0x410 -- the equipment word. Bits 11-9 (0x0e00) should 
be the number of serial ports, 0 to 4 (so 5-7 is also a sanity check) and if 
BIOSes can be expected to zero out the non-used base-addresses (at 0x400, 
0x402, 0x404, 0x406) that's another sanity check. Don't know if they can 
though...

Rene.

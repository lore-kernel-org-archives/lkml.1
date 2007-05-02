Return-Path: <linux-kernel-owner+w=401wt.eu-S2993159AbXEBVN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993159AbXEBVN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766954AbXEBVN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:13:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993159AbXEBVNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:13:25 -0400
Message-ID: <4638FE91.6050001@redhat.com>
Date: Wed, 02 May 2007 17:11:45 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] firewire: char device interface
References: <4637A29F.6070302@redhat.com>	<20070502090007.GA28174@infradead.org>	<tkrat.087ee29add656926@s5r6.in-berlin.de>	<tkrat.350cb4dfe522266e@s5r6.in-berlin.de>	<tkrat.65aea95f1451c211@s5r6.in-berlin.de>	<tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <17976.44988.734513.121919@smtp.charter.net>
In-Reply-To: <17976.44988.734513.121919@smtp.charter.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
>>>>>> "Stefan" == Stefan Richter <stefanr@s5r6.in-berlin.de> writes:
> 
> Stefan> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Stefan> ---
> Stefan>  drivers/firewire/fw-cdev.c    |  954 ++++++++++++++++++++++++++++++++++
> Stefan>  include/linux/firewire-cdev.h |  268 +++++++++
> Stefan>  2 files changed, 1222 insertions(+)
> 
> Stefan> Index: linux_juju/include/linux/firewire-cdev.h
...
> Stefan> +#define RCODE_SEND_ERROR		0x10
> Stefan> +#define RCODE_CANCELLED			0x11
> Stefan> +#define RCODE_BUSY			0x12
> Stefan> +#define RCODE_GENERATION		0x13
> Stefan> +#define RCODE_NO_ACK			0x14
> Stefan> +
> Stefan> +#define SCODE_100			0x0
> Stefan> +#define SCODE_200			0x1
> Stefan> +#define SCODE_400			0x2
> Stefan> +#define SCODE_800			0x3
> Stefan> +#define SCODE_1600			0x4
> Stefan> +#define SCODE_3200			0x5
> 
> These are also defined in fw-transaction.h, though that file doesn't
> have all the values.  Can these just be combined into a single
> fw-constants.h file instead?  
> 
> I honestly haven't checked all your defines....

The firewire-cdev.h file is meant to be a self-contained userspace header file 
and shouldn't include other kernel header files.  All duplicated values are 
standardized ieee1394 values and won't ever change.  I should put a #ifndef 
__FW_COMMON_DEFINES protection around the duplicate values, I guess, but I'm 
just wondering why I never saw a "symbol redefined" warning...

Kristian


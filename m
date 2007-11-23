Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbXKWDFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbXKWDFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 22:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXKWDF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 22:05:29 -0500
Received: from smtpoutm.mac.com ([17.148.16.67]:56387 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbXKWDF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 22:05:28 -0500
In-Reply-To: <20071123012911.3266dba6@the-village.bc.nu>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net> <20071123012911.3266dba6@the-village.bc.nu>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <BAAE8DE3-B96F-4EA8-B8CC-B2BD252B7259@mac.com>
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, kune@deine-taler.de, johannes@sipsolutions.net
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [RFC] Documentation about unaligned memory access
Date: Thu, 22 Nov 2007 22:04:34 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 22, 2007, at 20:29:11, Alan Cox wrote:
>> Most architectures are unable to perform unaligned memory  
>> accesses. Any unaligned access causes a processor exception.
>
> Not all. Some simply produce the wrong answer - thats oh so much  
> more exciting.

As one example, the MicroBlaze soft-core processor family designed  
for use on Xilinx FPGAs will (by default) simply forcibly zero the  
lower bits of the unaligned address, such that the following code  
will fail mysteriously:

const char foo[] = { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07 };
printf("0x%08lx 0x%08lx 0x%08lx 0x%08lx\n",
		*((u32 *)(foo+0)),
		*((u32 *)(foo+1)),
		*((u32 *)(foo+2)),
		*((u32 *)(foo+3)));

Instead of outputting:
0x00010203 0x01020304 0x02030405 0x03040506

It will output:
0x00010203 0x00010203 0x00010203 0x00010203

Other embedded architectures have very similar problems.  Some may  
provide an "unaligned data access" exception, but offer insufficient  
information to repair the damage and resume execution.

Cheers,
Kyle Moffett


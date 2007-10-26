Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbXJZAyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbXJZAyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXJZAyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:54:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34238 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbXJZAyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:54:36 -0400
Message-ID: <47213AA6.6040909@garzik.org>
Date: Thu, 25 Oct 2007 20:53:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Karsten Keil <kkeil@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ISDN/capidrv: fix casting warning
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org> <42205df7291ce7109866f9dbb5d06e481337e776.1193299380.git.jeff@garzik.org> <20071025095111.GA22353@pingi.kke.suse.de>
In-Reply-To: <20071025095111.GA22353@pingi.kke.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Keil wrote:
> On Thu, Oct 25, 2007 at 04:06:16AM -0400, Jeff Garzik wrote:
>> drivers/isdn/capi/capidrv.c: In function 'if_sendbuf':
>> drivers/isdn/capi/capidrv.c:1865: warning: cast from pointer to integer
>> of different size
>>
>> We are passing a kernel pointer, skb->data, but the interface itself is
>> limited to 32 bits.  A future changeset may want to mark this code
>> 32-bit only, if it turns out cmsg->Data value truncation on 64-bit
>> platforms is problematic in practice.
>>
> 
> I think I should really add somewhere a comment for this issue.
> This field is not used in practice in linux kernel (neither in 32 or
> 64 bit), but should have some value, since a CAPI message trace will
> display it.
> The correct value in the 32 bit case is the address of the
> data, in 64 bit it makes no sense, maybe we should use 0 here.

So noted...  I will make sure the next revision of the patch fulfills 
all your wishes :)

	Jeff



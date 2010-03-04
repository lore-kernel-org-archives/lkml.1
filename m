Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0CDInh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:43:37 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45735 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754578Ab0CDIng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:43:36 -0500
X-Sasl-enc: YtNxnuFU0aJgoSR26cnoQ11XMt6/N0xafpWu1ZbcK5C5 1267692215
Message-ID: <4B8F72B5.3000408@ladisch.de>
Date: Thu, 04 Mar 2010 09:43:33 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Magnus Lynch <maglyx@gmail.com>
CC: venkatesh.pallipadi@intel.com, vojtech@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hpet: factor timer allocate from open
References: <be233a491002282130m3c637cfbw6648a77548241a64@mail.gmail.com>	 <4B8B901E.4050302@ladisch.de> <be233a491003031859s7d409e11k599a319ce04b7696@mail.gmail.com>
In-Reply-To: <be233a491003031859s7d409e11k599a319ce04b7696@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Lynch wrote:
> On Mon, Mar 1, 2010 at 1:59 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> > Applications might want to use HPET_INFO to find out which timer they
> > got, so I think the driver cannot avoid allocating a timer in this case.
> 
> Oh, I missed commenting this in my first reply. I chose to make
> HPET_INFO specify timer -1 in case a timer isn't currently allocated.
> You think there are extant cases of programs depending on open then
> immediate HPET_INFO having a timer allocated? Seems obscure to me.

Get information about the just allocated timer seems to be the main
purpose of this ioctl to me.  None of the fields in struct hpet_info
looks to be interesting to an application that only wants to read the
main timer through mmap().

> If so I can change that. I did add the explicit form of allocating
> timers to accomodate such a case hypothetically (open, allocate timer,
> get info).

This wouldn't be backwards compatible.


Regards,
Clemens

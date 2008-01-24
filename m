Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYAXGdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYAXGdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 01:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYAXGdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 01:33:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:54291 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbYAXGdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 01:33:46 -0500
Cc: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Message-Id: <8642742F-E8BF-43C7-9FE4-AAF54855ECF7@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: benh@kernel.crashing.org
In-Reply-To: <1201156120.6815.48.camel@pasglop>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH] [POWERPC] Always build setup-bus.c on powerpc
Date: Thu, 24 Jan 2008 00:33:34 -0600
References: <Pine.LNX.4.64.0801240006380.21347@blarg.am.freescale.net> <1201156120.6815.48.camel@pasglop>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24, 2008, at 12:28 AM, Benjamin Herrenschmidt wrote:

>
> On Thu, 2008-01-24 at 00:07 -0600, Kumar Gala wrote:
>> The common arch/powerpc code calls in to functions in setup-bus.c
>> so some builds of ppc32 would fail.
>>
>> Note, ppc32 usage of setup-irq.c is limited to arch/ppc and should be
>> removed when arch/ppc goes away.
>
> I don't understand... the old code would build setup-bus.o for both
> PPC32 and PPC64 cases, how did you make it fail ?

The patch is bogus.  The old makefile rules looked like:

obj-$(CONFIG_PPC64) += setup-bus.o
obj-$(CONFIG_PPC32) += setup-irq.o

pmac most like builds because CONFIG_HOTPLUG pulls in setup-bus.o

(I'll fix my foobar'd patch and send this via Paul).

- k


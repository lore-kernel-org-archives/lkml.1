Return-Path: <linux-kernel-owner+w=401wt.eu-S1761920AbYBZAFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761920AbYBZAFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760298AbYBZAFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:05:14 -0500
Received: from rtr.ca ([76.10.145.34]:3150 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759532AbYBZAFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:05:11 -0500
Message-ID: <47C3585D.8070701@rtr.ca>
Date: Mon, 25 Feb 2008 19:07:57 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, jon@ngndg.com,
       LKML <linux-kernel@vger.kernel.org>, Saeed Bishara <saeed@marvell.com>
Subject: Re: Sata-MV, Intergated Sata Device Support
References: <1176673884.5109.30.camel@Desktop> <47C35203.20402@garzik.org>
In-Reply-To: <47C35203.20402@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jon Li wrote:
>> Hello,
>>
>> I am curious as to whether there are plans to add support for integrated
>> sata devices.  I personally want to add support for a 60x1C0 based
>> device (pci:id = 0x5182).  I think adding support should be relatively
>> simple, except for a few issues outlined below.
>>
>> In the original mvSata.c (ver3.4) that has 0x5182 support, the config
>> space is as such:
>>
>> case MV_SATA_DEVICE_ID_5182:
>>         pAdapter->numberOfChannels = MV_SATA_5182_PORT_NUM;
>>         pAdapter->numberOfUnits = 1;
>>         pAdapter->portsPerUnit = 2;
>>         pAdapter->sataAdapterGeneration = MV_SATA_GEN_IIE;
>>         /*The integrated sata core chip based on 60x1 C0*/
>>         pAdapter->chipIs60X1C0 = MV_TRUE;
>>         pAdapter->hostInterface = MV_HOST_IF_INTEGRATED;
>>         pAdapter->mainMaskOffset = 0x20024; /*the iobaseaddress is
>> 0x60000*/
>>         pAdapter->mainCauseOffset = 0x20020;
>>         break;
>>
>> I have not yet figured out how all these values are defined in sata-mv.c
>> (ver 0.8).  Specifically, where do I define "numberOfChannels" which
>> should equal 2, and "numberOfUnits" which obviously equals 1?
>>
>> I have a current config space (not completed) for sata-mv.c which is:
>>
>>     {  /* chip_5182 */
>>         .sht        = &mv_sht,
>>         .flags        = (MV_COMMON_FLAGS | MV_6XXX_FLAGS |
>>                    MV_FLAG_DUAL_HC),
>>         .pio_mask    = 0x1f,    /* pio0-4 */
>>         .udma_mask    = 0x7f,    /* udma0-6 */
>>         .port_ops    = &mv6_ops,
>>     },
...

Saeed:  isn't this what your SOC patches already implemented for us?
As near as I can tell, sata_mv now already has support for the 60x1C0.

-ml

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0CCKlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:41:21 -0500
Received: from mail-bw0-f212.google.com ([209.85.218.212]:39123 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0CCKlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:41:19 -0500
Message-ID: <4B8E3CB1.10902@ru.mvista.com>
Date: Wed, 03 Mar 2010 13:40:49 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Sergei Shtylyov <sshtylyov@mvista.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] ahci: Introduce ahci_set_em_messages()
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru> <20100302182939.GI3445@oksana.dev.rtsoft.ru> <4B8D80C3.1050006@ru.mvista.com> <4B8D9CED.7040603@garzik.org>
In-Reply-To: <4B8D9CED.7040603@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jeff Garzik wrote:

>>> Factor out some ahci_em_messages handling code from ahci_init_one().
>>> We would like to reuse it for non-PCI devices.
>>>
>>> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
>>> ---
>>> drivers/ata/ahci.c | 41 ++++++++++++++++++++++++-----------------
>>> 1 files changed, 24 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
>>> index 18443e9..6694b17 100644
>>> --- a/drivers/ata/ahci.c
>>> +++ b/drivers/ata/ahci.c
>>> @@ -3040,6 +3040,29 @@ static inline void
>>> ahci_gtf_filter_workaround(struct ata_host *host)
>>> {}
>>> #endif
>>>
>>> +static void ahci_set_em_messages(struct ahci_host_priv *hpriv,
>>> + struct ata_port_info *pi)
>>> +{
>>> + u8 messages;
>>> + void __iomem *mmio = hpriv->mmio;
>>> + u32 em_loc = readl(mmio + HOST_EM_LOC);
>>> + u32 em_ctl = readl(mmio + HOST_EM_CTL);
>>> +
>>> + if (!ahci_em_messages || !(hpriv->cap & HOST_CAP_EMS))
>>> + return;
>>> +
>>> + messages = (em_ctl & EM_CTRL_MSG_TYPE) >> 16;
>>> +
>>> + /* we only support LED message type right now */
>>> + if ((messages & 0x01) && (ahci_em_messages == 1)) {
>>> + /* store em_loc */
>>> + hpriv->em_loc = ((em_loc >> 16) * 4);
>>
>> Could drop unneeded parens, while at it...
>
> While not strictly necessary, parens often help with readability.  I 
> think the above code looks fine as-is.  If the reader has to waste a 
> few seconds recalling C's operator precedence, that detracts from the 
> easy reading of the code.  Not everyone is like me and has worked on a 
> C compiler, you know ;-)

   Come on, parens around the right arg of = are pretty 
counter-intuitive and so don't add to the readability. :-)

>     Jeff

MBR, Sergei


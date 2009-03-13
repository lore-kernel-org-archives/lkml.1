Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZCMJBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZCMJBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZCMJBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:01:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44632 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbZCMJB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:01:29 -0400
Message-ID: <49BA20E1.70607@redhat.com>
Date: Fri, 13 Mar 2009 10:01:21 +0100
From: Ivan Vecera <ivecera@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jiri Pirko <jpirko@redhat.com>
CC: Michal Schmidt <mschmidt@redhat.com>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] 8139cp: allow to set mac address on running device
References: <20090312162730.GA20153@psychotron.englab.brq.redhat.com> <20090312181121.79e297a2@brian.englab.brq.redhat.com> <20090312174641.GC20153@psychotron.englab.brq.redhat.com>
In-Reply-To: <20090312174641.GC20153@psychotron.englab.brq.redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Pirko wrote:
> Thu, Mar 12, 2009 at 06:11:21PM CET, mschmidt@redhat.com wrote:
>> On Thu, 12 Mar 2009 17:27:31 +0100
>> Jiri Pirko <jpirko@redhat.com> wrote:
>>
>>> +	cpw32_f(MAC0 + 0, le32_to_cpu (*(__le32 *) (dev->dev_addr +
>>> 0)));
>>> +	cpw32_f(MAC0 + 4, le32_to_cpu (*(__le32 *) (dev->dev_addr +
>>> 4)));
>> You're writing to the card, so using *_to_cpu looks suspicious.
> Well, I'm using the same approach as it is already done in function
> cp_init_hw(). Quote:
> 
>  /* Restore our idea of the MAC address. */
>  cpw32_f (MAC0 + 0, le32_to_cpu (*(__le32 *) (dev->dev_addr + 0)));
>  cpw32_f (MAC0 + 4, le32_to_cpu (*(__le32 *) (dev->dev_addr + 4)));
> 
Yes, that's right but I would use more cleaner approach:
===
u32 low, high;
low  = addr[0] | (addr[1] << 8) | (addr[2] << 16) | (addr[3] << 24);
high = addr[4] | (addr[5] << 8);
cpw32_f(MAC0 + 0, low);
cpw32_f(MAC0 + 4, high);
===

Ivan

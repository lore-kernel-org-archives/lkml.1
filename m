Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYEZK2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYEZK2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 06:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYEZK2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 06:28:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44892 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYEZK2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 06:28:32 -0400
Message-ID: <483A9050.5000206@jp.fujitsu.com>
Date: Mon, 26 May 2008 19:26:24 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       drzeus-list@drzeus.cx
Subject: Re: [patch, -git] pcie hotplug bootup crash fix
References: <20080524165828.GA29993@elte.hu>	<20080524104024.a33116a3.akpm@linux-foundation.org>	<483A7663.4000700@jp.fujitsu.com>	<20080526084709.GA2182@elte.hu> <20080526015232.5faac5bb.akpm@linux-foundation.org>
In-Reply-To: <20080526015232.5faac5bb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 26 May 2008 10:47:09 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:
>>
>>> I updated Ingo's patch. If it's ok, I'll send it to Jess Barnes with 
>>> some other patches for the other pciehp regression problems.
>> looks good to me, thanks Kenji.
>>
> 
> It's a bit sad to add a large workaround like this.  I'm surprised
> that fixing it properly is considered unviable for 2.6.26.  Normally
> these fixes are pretty simple - just request the IRQ a bit later?
> 

Although I have not considered how to implement proper fix deeply,
I don't think it's so simple. For example, current pciehp is doing
like this:

(1) some initialization
(2) request_irq()
(3) issue command
(4) initialize slot data structure

Maybe we want to do (2) after (4) to fix the problem. But if we
simply move (2) after (4), we cannot detect the command completion
event at (3) and it will cause command timeout.

It's just an example, and there might be other things like this.
This example might be fixed simply, but all my worry is that fixing
this quickly might cause another regressions. This is why I think
Ingo's approach is better in a short term.

And another reason is I'm very nervous because I already caused
many problems in pciehp since 2.6.26-rcX... :(

Thanks,
Kenji Kaneshige





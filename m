Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZCDNhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZCDNhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZCDNhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:37:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:48073 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbZCDNhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:37:13 -0500
Message-ID: <49AE83E6.4040608@kernel.org>
Date: Wed, 04 Mar 2009 22:36:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, pgnet.trash@gmail.com
Subject: Re: [PATCH 2.6.29-rc7 2/2] x86: disallow DAC for MCP51 PCI bridge
References: <49ADE82D.40103@kernel.org>	<49ADE9D3.6080000@kernel.org>	<20090304095727.707ac18c@lxorguk.ukuu.org.uk>	<49AE53B5.6000009@kernel.org> <20090304132945.2b242e63@lxorguk.ukuu.org.uk>
In-Reply-To: <20090304132945.2b242e63@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 13:36:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> x86 is blacklisting DAC for everything VIA. :-)
> 
> I'd assume that comes from published docs given VIA actually publish
> stuff if you ask nicely.

Dunno the history but it's from the time before VIA begins publishing.
It's probably worthwhile to refine the blacklisting.

>> * MCP51 is a very old chipset at this point (it's circa 2005).  Not
>>   many machine would be running with >4GB memory to begin with.
>>
>> * Given the above and scarcity of DAC on most end user machines
>>   (nothing on MCP51 does DAC by default), lack of reports isn't too
>>   surprising.
>>
>> * The board doesn't have a 64bit connector.  It can't be dodgy
>>   connector and sil24 is known to behave well with DAC.  The failure
>>   being specific to the particular machine doesn't seem likely.
>>
>> I'll ping nvidia about it but I think your bar is too high.
> 
> I don't think wanting to see *two* examples is a high bar.

I don't think it's an easy combination.  Circa 2005 desktop machine
with >4GB ram + DAC capable controller running Linux with owner who
will report seemingly random data corruption which will end up in the
correct hands and given that non-working DAC isn't too surprising of
the machines of that time and isn't very likely caused by random
component or connection failure, I think we'll be better off just
blacklisting it.  That said, I admit I'm more trigger happy with
blacklists than some people (I think it's generally better to have
working systems than chasing performance on not-so-common cases).

Anyways, I pinged Peer Chen on the issue.  Let's see whether he can
confirm it.

Thanks.

-- 
tejun

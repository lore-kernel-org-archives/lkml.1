Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZCDKLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZCDKLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZCDKLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:11:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:56443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZCDKLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:11:24 -0500
Message-ID: <49AE53B5.6000009@kernel.org>
Date: Wed, 04 Mar 2009 19:11:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, pgnet.trash@gmail.com
Subject: Re: [PATCH 2.6.29-rc7 2/2] x86: disallow DAC for MCP51 PCI bridge
References: <49ADE82D.40103@kernel.org>	<49ADE9D3.6080000@kernel.org> <20090304095727.707ac18c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090304095727.707ac18c@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 10:11:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 04 Mar 2009 11:39:15 +0900
> Tejun Heo <tj@kernel.org> wrote:
> 
>> MCP51 corrupts DAC transfers.  Disallow it.  Reported by pgnet on
>> bnc#463829.
> 
> So you have a single piece of evidence as I read it - from a single
> board that represents system with a very common chipset and no supporting
> errata information from the vendor.
> 
> That bug could easily be a faulty motherboard or dodgy connector or a
> specific hardware compatibility issue between two specific components. I
> don't think that can be considered sufficient evidence for adding
> sledgehammer sized workarounds that harm everyone elses performance and
> cripples such systems for certain kinds of work (eg video)
> 
> Insufficient evidence and google searches and other bug searches don't
> seem to be turning up any parallel cases so for the moment At the very
> least someone needs to reproduce the hardware configuration and see the
> same problem, and then repeat with a different DAC enabled card.
> 
> I don't believe this patch should go in ... yet. More information/testing
> is needed.

x86 is blacklisting DAC for everything VIA. :-)

* MCP51 is a very old chipset at this point (it's circa 2005).  Not
  many machine would be running with >4GB memory to begin with.

* Given the above and scarcity of DAC on most end user machines
  (nothing on MCP51 does DAC by default), lack of reports isn't too
  surprising.

* The board doesn't have a 64bit connector.  It can't be dodgy
  connector and sil24 is known to behave well with DAC.  The failure
  being specific to the particular machine doesn't seem likely.

I'll ping nvidia about it but I think your bar is too high.

Thanks.

-- 
tejun

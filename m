Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbXLTU5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbXLTU5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760858AbXLTU5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:57:17 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1927 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760820AbXLTU5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:57:15 -0500
Message-ID: <476AD6FD.3060700@myri.com>
Date: Thu, 20 Dec 2007 15:56:29 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Tony Camuso <tcamuso@redhat.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476AB920.7040604@myri.com> <476ABCBF.8090006@redhat.com> <20071220190833.GH29690@parisc-linux.org> <476ACB20.6030803@myri.com> <20071220201529.GJ29690@parisc-linux.org>
In-Reply-To: <20071220201529.GJ29690@parisc-linux.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2007 3:15 PM, Matthew Wilcox wrote:
> On Thu, Dec 20, 2007 at 03:05:52PM -0500, Loic Prylli wrote:
>   
>> I am not familiar with the tg3 driver, just trying to give a 5 minutes
>> look, it seems the typical cases where the pci-conf-space is used
>> intensively are with some rev in combination with the 82801
>> (TG3_FLG2_ICH_WORKAROUND) which I don't think support mmconfig anyway,
>> as well as some very specific PCI-X combinations
>> (TG3_FLAG_PCIX_TARGET_HWBUG) which are also very unlikely to support
>> mmconfig.
>>     
>
> It's not a question of whether the card supports mmconfig or not -- the
> card can't tell whether a first-256-byte pci config transaction was initiated through mmconfig, type1, type2, or even a bios call.
>   





I know the final device is not aware on how the config request was
originated. I am just saying platforms built around the Intel 82801
chipset (ICH2) don't support mmconfig at all. I would also not be
surprised if the platforms where tg3 needs TG3_FLAG_PCIX_TARGET_HWBUG
might also not support mmconfig (but for this second case, it's only
speculation based on seeing a couple posts about
TG3_FLAG_PCIX_TARGET_HWBUG where amd hypertransport/PCI-X chipsets where
mentioned). If you know of a platform that support mmconfig, and where
the tg3 does need to use relatively intensively pci-conf-space, I'll be
happy to be corrected.




> I'm just hacking together an implementation based on Ivan's suggestion
> to always use type 1 for the first 64 bytes.
>
>   



Whatever you think it's best. If you are only trying to address a
BAR-sizing/mmconfig temporary conflict, and think the "MCFG BIOS" or
other mmconfig problems are under control, that makes sense. If the need
arise for somebody, an option to select between 64 to 256 can be added
later.



Loic



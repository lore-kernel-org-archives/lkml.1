Return-Path: <linux-kernel-owner+w=401wt.eu-S1762990AbXLTVz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762990AbXLTVz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895AbXLTVzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:55:50 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1918 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753192AbXLTVzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:55:49 -0500
Message-ID: <476AE4BC.3040701@myri.com>
Date: Thu, 20 Dec 2007 16:55:08 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Tony Camuso <tcamuso@redhat.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476AB920.7040604@myri.com> <476ABCBF.8090006@redhat.com> <20071220190833.GH29690@parisc-linux.org> <476ACB20.6030803@myri.com> <20071220201529.GJ29690@parisc-linux.org> <476AD6FD.3060700@myri.com> <20071220210044.GK29690@parisc-linux.org>
In-Reply-To: <20071220210044.GK29690@parisc-linux.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2007 4:00 PM, Matthew Wilcox wrote:
> On Thu, Dec 20, 2007 at 03:56:29PM -0500, Loic Prylli wrote:
>   
>> I know the final device is not aware on how the config request was
>> originated. I am just saying platforms built around the Intel 82801
>> chipset (ICH2) don't support mmconfig at all. I would also not be
>> surprised if the platforms where tg3 needs TG3_FLAG_PCIX_TARGET_HWBUG
>> might also not support mmconfig (but for this second case, it's only
>> speculation based on seeing a couple posts about
>> TG3_FLAG_PCIX_TARGET_HWBUG where amd hypertransport/PCI-X chipsets where
>> mentioned). If you know of a platform that support mmconfig, and where
>> the tg3 does need to use relatively intensively pci-conf-space, I'll be
>> happy to be corrected.
>>     
>
> tg3 is available as an add-in pci card.  i have one.  i can plug it into
> a machine that does support mmconfig.
>   



That doesn't tell for sure your NIC has the specific rev that would
cause the hwbug workaround to be used. But let's assume so, your
combination would still works correctly (maybe a slightly non-optimal
network performance). A non-default mmconf=always option can help
maximize again the performance.

My starting point was that more systems could be supported out-of-the
box (vs not working at all) by using "type 1" more widely,. This would
not break anybody.  And this would not affect performance except on what
I initially called "obscure hardware or systems".

I already acknowledged in the previous email the possibility of a
performance impact, but it is still not clear to me whether it would be
widespread. The example you  mention is a buggy revision of a chip that
was designed to use memory-mapped IO, and has to use config-space
instead because the memory-mapped IO implementation is buggy (in most
cases only when used in combination with certain chipsets). How much
influence should a modest performance impact there influence the
decision-making?


Usually it's better to trade some performance for stability than the
reverse, and you loose the performance anyway when some many people
start using pci=nommconf by default on all their installs.


Loic


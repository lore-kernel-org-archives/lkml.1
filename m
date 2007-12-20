Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbXLTUGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbXLTUGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbXLTUGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:06:33 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1849 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753197AbXLTUGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:06:33 -0500
Message-ID: <476ACB20.6030803@myri.com>
Date: Thu, 20 Dec 2007 15:05:52 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Tony Camuso <tcamuso@redhat.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org> <476AAE99.7090301@redhat.com> <20071220181603.GF29690@parisc-linux.org> <476AB920.7040604@myri.com> <476ABCBF.8090006@redhat.com> <20071220190833.GH29690@parisc-linux.org>
In-Reply-To: <20071220190833.GH29690@parisc-linux.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2007 2:08 PM, Matthew Wilcox wrote:
> On Thu, Dec 20, 2007 at 02:04:31PM -0500, Tony Camuso wrote:
>   
>> Also, this solution also would allow us to remove the unreachable_devices()
>> routine and bitmap.
>>     
>
> Not really ... we probe reading address 0x100 to see if the device
> supports extended config space or not.  So we need to make that fail
> gracefully for the amd7111 case.
>   



pci_cfg_space_size()  is only done for PCI-express  or PCI-X mode 2
devices, so you still have eliminated the bulk of the problems which are
typically handling the legacy busses on modern machines. I don't know
what is the amd7111.



>   
>> Does anybody see a down side to this?
>>     
>
> It'll be slower than it would be if we used mmconfig directly.  Now yes,
> nobody should be using pci config space in performance critical paths
> ... but see the tg3 driver.
>   


I am not familiar with the tg3 driver, just trying to give a 5 minutes
look, it seems the typical cases where the pci-conf-space is used
intensively are with some rev in combination with the 82801
(TG3_FLG2_ICH_WORKAROUND) which I don't think support mmconfig anyway,
as well as some very specific PCI-X combinations
(TG3_FLAG_PCIX_TARGET_HWBUG) which are also very unlikely to support
mmconfig.

Even if I am wrong for the tg3, I don't really think mmconfig vs type1
could make a noticeable performance on any common systems (obscure
systems or hardware where it could potentially have a performance impact
could  use a non-default configuration).


Loic





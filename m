Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbYKGCiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbYKGCiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbYKGCiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:38:02 -0500
Received: from mga03.intel.com ([143.182.124.21]:24277 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbYKGCh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:37:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,560,1220252400"; 
   d="scan'208";a="72563358"
Message-ID: <4913AA03.5060807@intel.com>
Date: Fri, 07 Nov 2008 10:37:55 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 16/16 v6] PCI: document the new PCI boot parameters
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084531.GP3773@yzhao12-linux.sh.intel.com> <20081106043235.GA30292@kroah.com>
In-Reply-To: <20081106043235.GA30292@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Oct 22, 2008 at 04:45:31PM +0800, Yu Zhao wrote:
>>  Documentation/kernel-parameters.txt |   10 ++++++++++
>>  1 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 53ba7c7..5482ae0 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1677,6 +1677,16 @@ and is between 256 and 4096 characters. It is defined in the file
>>  		cbmemsize=nn[KMG]	The fixed amount of bus space which is
>>  				reserved for the CardBus bridge's memory
>>  				window. The default value is 64 megabytes.
>> +		assign-mmio=[dddd:]bb	[X86] reassign memory resources of all
>> +				devices under bus [dddd:]bb (dddd is the domain
>> +				number and bb is the bus number).
>> +		assign-pio=[dddd:]bb	[X86] reassign io port resources of all
>> +				devices under bus [dddd:]bb (dddd is the domain
>> +				number and bb is the bus number).
>> +		align-mmio=[dddd:]bb:dd.f  [X86] relocate memory resources of a
>> +				device to minimum PAGE_SIZE alignment (dddd is
>> +				the domain number and bb, dd and f is the bus,
>> +				device and function number).
> 
> This seems like a big problem.  How are we going to know to add these
> command line options for devices we haven't even seen/known about yet?
> 
> How do we know the bus ids aren't going to change between boots (hint,
> they are, pci bus ids change all the time...)
> 
> We need to be able to do this kind of thing dynamically, not fixed at
> boot time, which seems way to early to even know about this, right?
> 
> thanks,
> 
> greg k-h

Yes, I totally agree. Doing things dynamically is better.

The purpose of these parameters is to rebalance and align resources for 
device that has BARs encapsulated in various new capabilities (SR-IOV, 
etc.), because most of existing BIOSes don't take care of those BARs.

If we do resource rebalance after system is up, do you think there is 
any side effect or impact to other subsystem other than PCI (e.g. MTRR)?

I haven't had much thinking on the dynamical resource rebalance. If you 
have any idea about this, can you please suggest?

Regards,
Yu

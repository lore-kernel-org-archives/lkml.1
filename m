Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbYKGDBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYKGDBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 22:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYKGDBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 22:01:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:18704 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYKGDBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 22:01:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,560,1220252400"; 
   d="scan'208";a="460268466"
Message-ID: <4913AF89.2050504@intel.com>
Date: Fri, 07 Nov 2008 11:01:29 +0800
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
Subject: Re: [PATCH 15/16 v6] PCI: document the SR-IOV sysfs entries
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084515.GO3773@yzhao12-linux.sh.intel.com> <20081106043318.GB30292@kroah.com> <20081106044613.GA30397@kroah.com>
In-Reply-To: <20081106044613.GA30397@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Nov 05, 2008 at 08:33:18PM -0800, Greg KH wrote:
>> On Wed, Oct 22, 2008 at 04:45:15PM +0800, Yu Zhao wrote:
>>>  Documentation/ABI/testing/sysfs-bus-pci |   33 +++++++++++++++++++++++++++++++
>>>  1 files changed, 33 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
>>> index ceddcff..41cce8f 100644
>>> --- a/Documentation/ABI/testing/sysfs-bus-pci
>>> +++ b/Documentation/ABI/testing/sysfs-bus-pci
>>> @@ -9,3 +9,36 @@ Description:
>>>  		that some devices may have malformatted data.  If the
>>>  		underlying VPD has a writable section then the
>>>  		corresponding section of this file will be writable.
>>> +
>>> +What:		/sys/bus/pci/devices/.../iov/enable
>> Are you sure this is still the correct location with your change to
>> struct device?
> 
> Nevermind, this is correct.
> 
> But the bigger problem is that userspace doesn't know when these
> attributes show up.  So tools like udev and HAL and others can't look
> for them as they never get notified, and they don't even know if they
> should be looking for them or not.
> 
> Is there any way to tie these attributes to the "main" pci device so
> that they get created before the device is announced to the world?
> Doing that would solve this issue.
> 
> thanks,
> 
> greg k-h

Currently PCI subsystem has /sys/.../{vendor,device,...} bundled to the 
main PCI device (I suppose this means the entries are created by 
'device_add')

And after the PCI device is announced, 
/sys/.../{config,resourceX,rom,vpd,iov,...} get created depending on if 
these features are supported.

Making dynamic entries tie to the main PCI device would require PCI 
subsystem to allocate different 'bus_type' for the devices, right?

Regards,
Yu

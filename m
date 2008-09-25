Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYIYAXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYIYAXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 20:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYIYAWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 20:22:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:16448 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbYIYAWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 20:22:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=K4Qg4PVqaEmpp6ljGsXKCFfVDuQXodLGekJ+RMWk9XIfpO9eB4doCuBLHINwRslV5C
         CzRy2x9sgtfgRCY7LjARNUJAzTX6i1rGAi/1gdMNX/i+9qoErhg0SE5sJk0P1wKf7F0W
         WNh8x6jCvYGu7Skxv9WZCtjfCZpRE/yEUiukM=
Message-ID: <21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com>
Date: Thu, 25 Sep 2008 10:22:49 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: "David Miller" <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com,
       "Ingo Molnar" <mingo@elte.hu>, jbarnes@virtuousgeek.org,
       jesse.brandeburg@gmail.com
In-Reply-To: <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080923.150722.141587696.davem@davemloft.net>
	 <9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com>
	 <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz>
	 <20080923.211215.193696086.davem@davemloft.net>
	 <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 9:15 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 23 Sep 2008, David Miller wrote:
>
>> I did some snooping around, and while doing so I noticed that the PCI
>> mmap code for x86 doesn't do one bit of range checking on the size, or
>> any other aspect of the request, wrt. the MMIO regions actually mapped
>> in the BARs of the PCI device.
>
> Ugh, indeed. Added Ingo and Jesse to CC.
>
>> Yikes!
>>
>> It just does a reserve_memtype() on the address range, and says "ok".
>>
>> So if, for example, the X server tries to mmap() more than an MMIO bar
>> actually maps, the kernel lets the user do this.
>>
>> It would be very interesting to add the appropriate checks to
>> pci_mmap_page_range() in arch/x86/pci/i386.c, anyone who wants to do
>> this can use the code in arch/sparc64/kernel/pci.c:
>> __pci_mmap_make_offset() as a guide, and see what happens.
>
> Absolutely. Or we can even do some dirty hackery in userspace, like
> LD_PRELOADing X server and checking mmaps() that are close to MMIO regions
> of affected devices.
>
>> If the MMIO space regions of the video cards sit right before the
>> E1000E ones on the effected systems, that would pretty much
>> convince me that this is the kind of problem we are having here.
>
> Unfortunately, looking at the lspci outputs that are in
> https://bugzilla.novell.com/show_bug.cgi?id=425480 it seems to me that the
> MMIO regions are quite far away from each other.
>

Yup on my laptop these were far away and I wondered what could mangle
things that badly.

Well I'm out of the race, my attempts to re-write my eeprom using an
eeprom from an equivalent laptop
have totally failed and my BIOS won't boot anymore - so my laptop is == a brick.

Dave.

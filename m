Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYI2VNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYI2VNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 17:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYI2VMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 17:12:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYI2VMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 17:12:52 -0400
Date: Mon, 29 Sep 2008 22:56:34 +0200
From: Karel Zak <kzak@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akataria@vmware.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, avi@redhat.com,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>, Jun.Nakajima@intel.com,
       ksrinivasan@novell.com, Matthias Koenig <mkoenig@suse.de>
Subject: Re: Use CPUID to communicate with the hypervisor.
Message-ID: <20080929205634.GA2907@nb.net.home>
References: <1222472815.29886.43.camel@alok-dev1> <48DD799C.3070706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DD799C.3070706@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 05:09:00PM -0700, H. Peter Anvin wrote:
> Alok Kataria wrote:
>> +{
>> +	if (cpu_has_hypervisor) {
>> +		unsigned int eax, ebx, ecx, edx;
>> +		char hyper_vendor_id[13];
>> +
>> +		cpuid(HYPERVISOR_INFO_LEAF, &eax, &ebx, &ecx, &edx);
>> +		memcpy(hyper_vendor_id + 0, &ebx, 4);
>> +		memcpy(hyper_vendor_id + 4, &ecx, 4);
>> +		memcpy(hyper_vendor_id + 8, &edx, 4);
>> +		hyper_vendor_id[12] = '\0';
>> +		printk(KERN_INFO "Hypervisor vendor id %s\n", hyper_vendor_id);
>> +	}
>> +}
>> +
>
> This should be broken out into a separate file in cpu/*, because we  
> *will* need to detect hypervisors by other means.

 Yes. It would be nice to have "Hypervisor vendor id" somewhere in
 /sys or /proc. It seems that userspace is already hungry for that
 information:

 http://article.gmane.org/gmane.linux.utilities.util-linux-ng/1788

    Karel

-- 
 Karel Zak  <kzak@redhat.com>

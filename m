Return-Path: <linux-kernel-owner+w=401wt.eu-S936759AbZLQWe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936759AbZLQWe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 17:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935913AbZLQWe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 17:34:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:54695 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935903AbZLQWeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 17:34:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,415,1257148800"; 
   d="scan'208";a="477191764"
Message-ID: <4B2AB1F0.1020105@linux.intel.com>
Date: Thu, 17 Dec 2009 14:34:24 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] x86/apic: check global clockevent in lapic timer
 setup
References: <43F901BD926A4E43B106BF17856F07559A257B5C@orsmsx508.amr.corp.intel.com> <20091217194148.GB5414@lenovo> <43F901BD926A4E43B106BF17856F07559A257E3D@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F07559A257E3D@orsmsx508.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 02:31 PM, Pan, Jacob jun wrote:
>> Wouldn't be better to operate the same way as in case of "noapictimer"
>> boot option. I guess the non-pc x86 midplatforms you're mentioning
>> do not use SMP ever but just to be consistent in code.
>>
> [[JPAN]] We do use SMP with hyper threading in Moorestown.
> In that case we have a per cpu platform timer without global clockevent.
> so i think we don't want the dummy lapic event. we don't want to use the
> broadcast mechanism as mentioned in the comments before disabling lapic
> timer.
> 
> For moorestown, I can use x86_init.timers.setup_percpu_clockev
> abstraction function so that Moorestown platform does not need to call
> setup_boot_APIC_clock() if per cpu platform timer is used. so many IFs :).
> 
> But in the case of having constant and always on LAPIC timer, we still do
> not want the dummy lapic clockevent and the broadcast. we will just have
> per cpu always on local apic timers without global clockevent device.

OK, I'm not entirely sure I follow this, and I'm not sure someone trying
to understand the code in five years would, either.  I don't really see
the above translating into "we don't have a global clockevent, therefore
we shouldn't initialize (but should still not disable) the local APIC
timer."

	-hpa

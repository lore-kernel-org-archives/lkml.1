Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbYIYDvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbYIYDvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 23:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYIYDv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 23:51:26 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:41832 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbYIYDvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 23:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QqOE9YGQwYZydraA8RcvzWy5LUblbPev30yejbavg/yAmwZ2lEsY9lgTBjBVpUshUd
         mhB/oHvymf/6ydx4uIiUrTrFLfilds7kOoSOFQsLAak7xfvDoN8fP3o8OkS+D4XQ924T
         rlL97jxP6FYVx0bA6CCbtD0u3872da3z4D1Bs=
Message-ID: <21d7e9970809242051x17785159ya7510d92f705f3cf@mail.gmail.com>
Date: Thu, 25 Sep 2008 13:51:23 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: "Jiri Kosina" <jkosina@suse.cz>, "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, "Ingo Molnar" <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, jesse.brandeburg@gmail.com
In-Reply-To: <48DAF75D.4050908@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080923.150722.141587696.davem@davemloft.net>
	 <9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com>
	 <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz>
	 <20080923.211215.193696086.davem@davemloft.net>
	 <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz>
	 <21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com>
	 <alpine.LNX.1.10.0809250310190.4671@pegasus.suse.cz>
	 <48DAF75D.4050908@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 12:28 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Jiri Kosina wrote:
>>
>> On Thu, 25 Sep 2008, Dave Airlie wrote:
>>
>>> Well I'm out of the race, my attempts to re-write my eeprom using an
>>> eeprom from an equivalent laptop have totally failed and my BIOS won't boot
>>> anymore - so my laptop is == a brick.
>>
>> Uh oh. Shouldn't we put something like the patch below in Linus' tree
>> unless we get this sorted out? Otherwise more and more people who use -rc
>> kernels will run into this, and will get their hardware [hopefully
>> temporarily, but not all users are able to re-flash their network card
>> EEPROMs, right] bricked.
>>
>> I know that it is quite aggressive and is going to disable wired
>> networking on a lot of systems that have been functioning properly,
>> therefore RFC ...
>>
>>
>>
>> From: Jiri Kosina <jkosina@suse.cz>
>> Subject: [PATCH] [RFC] E1000E: temporarily disable e1000e driver
>>
>> E1000E: temporarily disable e1000e driver
>
> That seems a bit drastic, particularly when the debugging was beginning to
> point to another culprit.
>
> We have equal case at this point to disable r8169 and i915_drm, no?
>

No we actually are more likely unable to do anything from the kernel,
if its happening from userspace

firstly we need a reflash utility that is safe, otherwise people who
have the issue can't reproduce it,
and people who don't have the issue don't want to play with it.

I think e1000e may enable a BAR or something that causes the issue to
break this hw., I haven't seen it broken on any
machine where e1000e wasn't loaded yet. Again the r8169 might be the
same issue, but it maybe because the bar was enabled.

Dave.

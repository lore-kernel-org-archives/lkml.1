Return-Path: <linux-kernel-owner+w=401wt.eu-S965911AbXCFPEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965911AbXCFPEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965908AbXCFPEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:04:05 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:10891 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965912AbXCFPED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:04:03 -0500
Message-ID: <45ED82D9.6050204@codemonkey.ws>
Date: Tue, 06 Mar 2007 09:03:53 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.virtualization
To: Ingo Molnar <mingo@elte.hu>
CC: Gerd Hoffmann <kraxel@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
References: <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <45ED3121.8090308@suse.de> <20070306093436.GA30239@elte.hu> <45ED3F29.6000705@suse.de> <20070306102658.GA7478@elte.hu> <45ED4AD8.6020504@suse.de> <20070306115937.GA25313@elte.hu>
In-Reply-To: <20070306115937.GA25313@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Gerd Hoffmann <kraxel@suse.de> wrote:
> 
>>>> So in the end you would still have two different hypervisor ABI's, 
>>>> the VMI ROM just hides that.
>>> oh, but that way i have cleverly pushed the problem out of Linux and 
>>> into the VMI-ROM's domain ;) Which is all i care about.
>> Fine, so lets move kvm paravirtualitzation into vmi too (proof of 
>> concept code by Anthony Liguori exists) and kill one more item on the 
>> (linux) QA test matrix?  (just following your arguments, not that I'm 
>> confident it would actually help reducing QA effort).
> 
> yes - although obviously a KVM Linux guest does not need such an 
> interface - but it's a nice proof of concept to integrate other guest 
> OSs into KVM.

I disagree that a KVM Linux guest does not benefit from VMI.  Right now, 
your KVM paravirt interface only covers CR3 target caching and apic 
enhancements (neither of which I believe have made it into 2.6.21). 
Inevitably, things like MMU batching will be added.

Using paravirt_ops, this is going to require new kernels for the guests. 
  Every new paravirtualization feature will require a new guest kernel. 
  With VMI, one can add these features to any 2.6.21+ guest by just 
modifying the ROM (assuming a newer host).  Some features will require 
new VMI entry points but quite a lot will fall under the current entry 
points.

Of all the hypervisors, KVM is the easiest to use VMI with.  QEMU 
already supports option ROM loading and Zach just made some changes to 
allow a native ROM to be implemented very easily.

If we're going to use VMI for anything other than VMware, it seems to be 
that KVM should be what we use it for.

Regards,

Anthony Liguori

> 	Ingo


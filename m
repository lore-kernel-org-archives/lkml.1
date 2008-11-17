Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbYKQPGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbYKQPGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYKQPGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:06:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44624 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbYKQPGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:06:11 -0500
Date: Mon, 17 Nov 2008 13:04:27 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] x86: disable virt on kdump and emergency_restart
	(v3)
Message-ID: <20081117150427.GH4481@blackpad>
References: <1226598231-18311-1-git-send-email-ehabkost@redhat.com> <491FD283.60402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491FD283.60402@redhat.com>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 09:57:55AM +0200, Avi Kivity wrote:
> Eduardo Habkost wrote:
>> Hi,
>>
>> This is a new spin of the series to disable vmx on kdump and on
>> emergency_restart. Now we avoid doing the function pointer stuff by
>> moving 4 small KVM functions to a header, as inline functions. The code
>> looks much simpler now, but we have to be more careful because some
>> additional code will run on kdump and reboot even when KVM is never
>> loaded.
>>
>> I haven't tested the SVM changes on AMD CPUs. The changes are really
>> simple, but some testing is welcome.
>>
>> This series is against tip.git#master, that already contains the
>> nmi_shootdown_cpus() changes I've submitted previously.
>>
>>
>>   
>
> Looks good.  I am slightly uneasy about moving things away from vmx.h  
> and svm.h; can we keep them there and #include those headers directly?

I see them as bits of code that are being moved from KVM to the kernel
core. I think moving those bits outside arch/x86/kvm/ makes this more
clear: people can expect that code living in arch/x86/kvm/ is never
used if CONFIG_KVM was not set.

Because of their location, I thought svm.h and vmx.h had KVM-specific
code. Now I've noticed they are independent from KVM. May I move svm.h
and vmx.h to arch/x86/include/asm, then?

-- 
Eduardo

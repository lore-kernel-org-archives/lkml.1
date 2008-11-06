Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbYKFRrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbYKFRrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYKFRrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:47:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57007 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbYKFRrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:47:20 -0500
Date: Thu, 6 Nov 2008 15:45:38 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/16] x86: Emergency virtualization disable function
Message-ID: <20081106174538.GU5247@blackpad>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com> <1225810364-8990-9-git-send-email-ehabkost@redhat.com> <m1bpwu3wod.fsf@frodo.ebiederm.org> <20081105175235.GJ5247@blackpad> <4912BD67.8000704@redhat.com> <m1mygd2lxs.fsf@frodo.ebiederm.org> <4912C75B.8050508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4912C75B.8050508@redhat.com>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 12:30:51PM +0200, Avi Kivity wrote:
> Eric W. Biederman wrote:
>>
>>> If you want to be extra simple and safe, remove kvm from the equation.  Make the
>>> disabling code part of kdump/emergency_restart and only rely on the convention
>>> that cr3.vmxe == vmxon.
>>>     
>> Convention?
>>   
>
> There is a de-facto convention supported by at least vmware and kvm.  If  
> cr4.vmxe is 1, then we are in vmx operation.  If cr4.vmxe is 0, then we  
> are not in vmx operation.  This allows us to determine whether we need  
> to execute vmxoff without any APIs.

I am just worried about the probing needed to make sure CR4 is available
(and that the CR4.VMXE bit means what we expect it to mean), before we
try to read it and check VMXE. The same for SVM and the MSRs we need to
touch to disable SVM.

I prefer to reuse code that already exists on KVM and is working than
adding new probing code that I won't be able to test on all hardware
configurations.

-- 
Eduardo

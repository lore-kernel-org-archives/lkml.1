Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbXLSOxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbXLSOxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 09:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXLSOxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 09:53:10 -0500
Received: from il.qumranet.com ([82.166.9.18]:32980 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbXLSOxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 09:53:09 -0500
Message-ID: <47693054.20501@qumranet.com>
Date: Wed, 19 Dec 2007 16:53:08 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@qumranet.com>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] Guest kernel hangs in smp kvm for older kernels	prior
 to tsc sync cleanup
References: <47680173.6060606@qumranet.com> <20071218221930.GA26109@elte.hu> <4768BB43.1000609@qumranet.com> <4768FE27.7020305@qumranet.com> <47690304.1090903@qumranet.com> <20071219140624.GF21282@elte.hu>
In-Reply-To: <20071219140624.GF21282@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>> Avi Kivity wrote:
>>     
>>>  Testing shows wrmsr and rdtsc function normally.
>>>
>>> I'll try pinning the vcpus to cpus and see if that helps.
>>>
>>>       
>> It does.
>>     
>
> do we let the guest read the physical CPU's TSC? That would be trouble.
>
>   

vmx (and svm) allow us to add an offset to the physical tsc.  We set it
on startup to -tsc (so that an rdtsc on boot would return 0), and
massage it on vcpu migration so that guest rdtsc is monotonic.

The net effect is that tsc on a vcpu can experience large forward jumps
and changes in rate, but no negative jumps.

-- 
error compiling committee.c: too many arguments to function

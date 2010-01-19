Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438Ab0ASODY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab0ASODY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170Ab0ASODX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:03:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab0ASODW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:03:22 -0500
Message-ID: <4B55BBA6.2050806@redhat.com>
Date: Tue, 19 Jan 2010 16:03:18 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm: fix spurious interrupt with irqfd
References: <cover.1263402727.git.mst@redhat.com> <20100113171230.GB19798@redhat.com> <4B55B2B8.5090105@siemens.com>
In-Reply-To: <4B55B2B8.5090105@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 03:25 PM, Jan Kiszka wrote:
>
> For kvm-kmod, I'm fighting with compat support for
> eventfd_ctx_remove_wait_queue. I basically have a solution for kernels
> with CONFIG_KPROBES enabled (I need to look up unexported
> __wake_up_locked[_key]), but there will also be target kernels that do
> not have this. So there are three options for that case:
>
>   - Warn the user and fall back to the old racy approach
>   - (Somehow) disable KVM subsystems that use eventfd
>   - Refuse to start KVM
>
> As far as I understood, irqfd is interesting for device assignment and
> now also for vhost, right? What about ioeventfd? I just wonder how broad
> the impact of a broken or non-existent eventfd subsystem for kvm-kmod
> is. Any thoughts welcome.
>
>    

Since vhost is only a performance option (and there isn't a vhost-kmod) 
and device assignment wants a new kernel anyway (and only applies to a 
small subset of users), I think it's okay to drop it from kvm-kmod.  It 
should be sufficient to return 0 from KVM_CHECK_EXCEPTION and substitute 
some stubs for the functions.

ioeventfd/irqfd are useful for inter-guest wakeups, but there isn't any 
public code for that that I'm aware of.

> PS: If anyone forgot why Avi handed over this job, you should now
> remember why. :)
>    

It's only going to get more difficult, I'm afraid.  The list of old 
kernels keeps growing and we're going to depend on core kernel 
functionality more and more.

Luckily for me you accepted in time...

-- 
error compiling committee.c: too many arguments to function


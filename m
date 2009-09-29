Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZI2IaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZI2IaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 04:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZI2IaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 04:30:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbZI2IaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 04:30:09 -0400
Message-ID: <4AC1C59F.6010703@redhat.com>
Date: Tue, 29 Sep 2009 10:30:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2: kvm 4/4] Fix hotplug of CPUs for KVM.
References: <1254197072-889-1-git-send-email-zamsden@redhat.com> <1254197072-889-2-git-send-email-zamsden@redhat.com> <1254197072-889-3-git-send-email-zamsden@redhat.com> <1254197072-889-4-git-send-email-zamsden@redhat.com> <1254197072-889-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1254197072-889-5-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 06:04 AM, Zachary Amsden wrote:
> Both VMX and SVM require per-cpu memory allocation, which is done at module
> init time, for only online cpus.
>
> Backend was not allocating enough structure for all possible CPUs, so
> new CPUs coming online could not be hardware enabled.
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e27b7a9..2cd8bc2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1716,9 +1716,6 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
>   {
>   	int cpu = (long)v;
>
> -	if (!kvm_usage_count)
> -		return NOTIFY_OK;
> -
>   	val&= ~CPU_TASKS_FROZEN;
>   	switch (val) {
>   	case CPU_DYING:
>    

I still don't see how this bit can work.  Maybe if we move the 
notification registration to the point where kvm_usage_count is bumped.

-- 
error compiling committee.c: too many arguments to function


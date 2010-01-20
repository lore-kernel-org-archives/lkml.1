Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921Ab0ATXQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0ATXQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472Ab0ATXQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:16:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58402 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab0ATXQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:16:44 -0500
Message-ID: <4B578E93.9040709@zytor.com>
Date: Wed, 20 Jan 2010 15:15:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: mingo@elte.hu, tglx@linutronix.de, andreas.herrmann3@amd.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86, cacheinfo: Calculate L3 indexes
References: <1263899279-30739-1-git-send-email-bp@amd64.org> <1263899279-30739-4-git-send-email-bp@amd64.org>
In-Reply-To: <1263899279-30739-4-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 03:07 AM, Borislav Petkov wrote:
> We need to know the valid L3 indexes interval when disabling them over
> /sysfs. Do that when the core is brought online and add boundary checks
> to the sysfs .store attribute.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> @@ -161,6 +162,7 @@ struct _cpuid4_info_regs {
>  	union _cpuid4_leaf_ecx ecx;
>  	unsigned long size;
>  	unsigned long can_disable;
> +	unsigned int l3_indexes;
>  };
>  

Hmmm... 32, 64, 64, 32 bits... we could move up the l3_indexes variable
here.   However, more likely is that "size" and "can_disable" have no
business being unsigned long in the first place -- especially the latter
seems to be actually used as a boolean, and really should be "bool".

Second, the preferred plural of "index" is "indices" (although both are
correct and present in the kernel source.)

	-hpa

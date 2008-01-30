Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbYA3HSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbYA3HSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYA3HSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:18:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52296 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYA3HSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:18:03 -0500
Message-ID: <47A02483.5000606@zytor.com>
Date: Tue, 29 Jan 2008 23:17:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: yi.y.yang@intel.com
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.24] x86: add sysfs interface for cpuid module
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>	 <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>	 <479F4B99.4060701@zytor.com> <1201643817.12722.30.camel@yangyi-dev.bj.intel.com>
In-Reply-To: <1201643817.12722.30.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yi Yang wrote:
>>
>> It's broken, because it doesn't take into account the fact that Intel 
>> broke CPUID level 4 and made it "repeating" (neither did the cpuid char 
>> device, because it predated the Intel braindamage; I've had a patch for 
>> it privately for a while, but didn't push it upstream because paravirt 
>> broke it royally and I wanted the situation to settle down.)

> level 4 doesn't result in repeating on Intel CPU, cpuid module sets
> file offset to level, so cat /dev/cpu/*/cpuid will run cpuid instruction
> continuously.

The issue is that Intel suddenly made CPUID ECX-sensitive, which there 
is no way to represent.

As far as cat /dev/cpu/*/cpuid, that's a user error.

	-hpa


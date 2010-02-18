Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab0BRR0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:26:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43232 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757583Ab0BRR0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:26:34 -0500
Message-ID: <4B7D782F.20102@zytor.com>
Date: Thu, 18 Feb 2010 09:26:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 34/35] x86: use num_processors for possible cpus
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org> <1265793639-15071-35-git-send-email-yinghai@kernel.org> <4B7C98B9.1090903@zytor.com> <4B7CA825.9090309@kernel.org>
In-Reply-To: <4B7CA825.9090309@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 06:38 PM, Yinghai Lu wrote:
>>
>> I'm confused by this one.  This would seem to mean that unless you're
>> specifying possible_cpus= then you are not treating anything as
>> hotpluggable.
>>
>> This is clearly wrong, and it would appear to go the wrong direction in
>> terms of what is safe.
>>
>> What am I missing here?
> 
> per_cpu setup will allocate some mem for every cpu according to possible cpus.
> 

Yes, and I have repeatedly requested that we allocate the memory on the
first up of a disabled CPU rather than eagerly, but in *most*
configurations the amount is relatively small.

> no spec says that we should disable cpus entries in MADT as hotplug cpus.

Reality seems to, though.  Consider the bug report that led to patch
681ee44d40d7c93b42118320e4620d07d8704fd6 for example.

> also how many system that support hotplug cpus there?

In terms of physical machines, not all that many; however, it is getting
common to use CPU hotplug for virtual environments so they can be
dynamically scaled.

	-hpa


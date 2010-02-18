Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313Ab0BRTyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:54:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34589 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab0BRTyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:54:06 -0500
Message-ID: <4B7D9ABB.7020806@zytor.com>
Date: Thu, 18 Feb 2010 11:53:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 34/35] x86: use num_processors for possible cpus
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org> <1265793639-15071-35-git-send-email-yinghai@kernel.org> <4B7C98B9.1090903@zytor.com> <4B7CA825.9090309@kernel.org> <4B7D782F.20102@zytor.com> <alpine.DEB.2.00.1002181340380.7486@router.home>
In-Reply-To: <alpine.DEB.2.00.1002181340380.7486@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 11:48 AM, Christoph Lameter wrote:
>>
>> Yes, and I have repeatedly requested that we allocate the memory on the
>> first up of a disabled CPU rather than eagerly, but in *most*
>> configurations the amount is relatively small.
> 
> The size of the static per cpu segment is likely around 30k and you will
> likely add another 30k in dynamic allocations.
> 
> As I have also repeatedly stated: Dynamic percpu data allocation when
> onlining / offlining processors will complicate locking (cannot rely on
> percpu be present anymore) and introduce numerous additional
> hotplug notifiers into subsystems.

I did state explicitly "on first up".  Trying to free it would be
insane.  There are a couple of subsystems which are percpu memory
pigs... so far it's not clear any of them actually matters in a
production kernel.  60K * 16 phantom processors is still ~ 1 MB, which
probably isn't enough to worry about but isn't great.

	-hpa

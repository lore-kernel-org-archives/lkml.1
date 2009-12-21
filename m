Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZLURVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZLURVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 12:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbZLURVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 12:21:05 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:45956 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbZLURVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 12:21:04 -0500
Message-ID: <4B2FAE7B.9030005@codemonkey.ws>
Date: Mon, 21 Dec 2009 11:20:59 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <4B2F978D.7010602@redhat.com> <4B2F9C85.7070202@gmail.com> <4B2FA42F.3070408@codemonkey.ws> <4B2FA655.6030205@gmail.com>
In-Reply-To: <4B2FA655.6030205@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 10:46 AM, Gregory Haskins wrote:
> The very best you can hope to achieve is 1:1 EOI per signal (though
> today virtio-pci is even worse than that).  As I indicated above, I can
> eliminate more than 50% of even the EOIs in trivial examples, and even
> more as we scale up the number of devices or the IO load (or both).
>    

If optimizing EOI is the main technical advantage of vbus, then surely 
we could paravirtualize EOI access and get that benefit in KVM without 
introducing a whole new infrastructure, no?

>> This is a
>> light weight exit today and will likely disappear entirely with newer
>> hardware.
>>      
> By that argument, this is all moot.  New hardware will likely obsolete
> the need for venet or virtio-net anyway.

Not at all.  But let's focus on concrete data.  For a given workload, 
how many exits do you see due to EOI?  They should be relatively rare 
because obtaining good receive batching is pretty easy.  Considering 
these are lightweight exits (on the order of 1-2us), you need an awfully 
large amount of interrupts before you get really significant performance 
impact.  You would think NAPI would kick in at this point anyway.

Do you have data demonstrating the advantage of EOI mitigation?

Regards,

Anthony Liguori

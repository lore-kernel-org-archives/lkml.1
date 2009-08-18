Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbZHRTIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbZHRTIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 15:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbZHRTIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 15:08:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48769 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZHRTIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 15:08:17 -0400
Message-ID: <4A8AFC2B.8020406@redhat.com>
Date: Tue, 18 Aug 2009 22:08:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Gregory Haskins <gregory.haskins@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for vbus_driver
 objects
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <4A8A674E.8070200@redhat.com> <4A8ABEC9.6090006@gmail.com> <200908182020.11126.arnd@arndb.de>
In-Reply-To: <200908182020.11126.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2009 09:20 PM, Arnd Bergmann wrote:
>> Well, the interrupt model to name one.
>>      
> The performance aspects of your interrupt model are independent
> of the vbus proxy, or at least they should be. Let's assume for
> now that your event notification mechanism gives significant
> performance improvements (which we can't measure independently
> right now). I don't see a reason why we could not get the
> same performance out of a paravirtual interrupt controller
> that uses the same method, and it would be straightforward
> to implement one and use that together with all the existing
> emulated PCI devices and virtio devices including vhost_net.
>    

Interesting.  You could even configure those vectors using the standard 
MSI configuration mechanism; simply replace the address/data pair with 
something meaningful to the paravirt interrupt controller.

I'd have to see really hard numbers to be tempted to merge something 
like this though.  We've merged paravirt mmu, for example, and now it 
underperforms both hardware two-level paging and software shadow paging.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


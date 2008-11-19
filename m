Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYKSKGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYKSKGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 05:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYKSKF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 05:05:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:49453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbYKSKF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 05:05:59 -0500
Message-ID: <4923E4D5.4070202@kernel.org>
Date: Wed, 19 Nov 2008 19:05:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Leon Woestenberg <leon.woestenberg@gmail.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       James.Bottomley@hansenpartnership.com
Subject: Re: pci_map_sg() does not coalesce adjacent physical memory? x86
References: <20081119142016E.fujita.tomonori@lab.ntt.co.jp>	 <c384c5ea0811182222l7f0e3131tc1cc20ffba5175c@mail.gmail.com>	 <20081119155847U.fujita.tomonori@lab.ntt.co.jp>	 <20081119165915A.fujita.tomonori@lab.ntt.co.jp> <c384c5ea0811190145y78803fbboecfcf6ebd652ee03@mail.gmail.com>
In-Reply-To: <c384c5ea0811190145y78803fbboecfcf6ebd652ee03@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 19 Nov 2008 10:05:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leon Woestenberg wrote:
> Hello,
> 
> On Wed, Nov 19, 2008 at 8:58 AM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
>> On Wed, 19 Nov 2008 15:58:12 +0900
>> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>> On Wed, 19 Nov 2008 07:22:31 +0100
>> - pci_map_sg/dma_map_sg are used with a scatter gather list that
>> doesn't come from the block layer (e.g. some network drivers do).
>>
> This is the point I then want to make: we have pci_map_sg() users in
> other system than the block layer, the network and v4l2 subsystems,
> why cannot they benefit from coalescing?

Because pci_map_sg() doesn't know the memory access limits of the
controller as block layer does.

> Should they copy the block layer coalescing implementation, or should
> that implementation be made more generic and live outside the block
> sub system?

The latter sounds like a good idea to me.

Thanks.

-- 
tejun

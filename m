Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbYKYQRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbYKYQRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYKYQRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:17:08 -0500
Received: from mout-xforward.kundenserver.de ([212.227.17.5]:55688 "EHLO
	mout-xforward.kundenserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbYKYQRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:17:07 -0500
Message-ID: <492C2502.7070709@vlnb.net>
Date: Tue, 25 Nov 2008 19:17:06 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Vladislav Bolkhovitin <vst@vlnb.net>, Wu Fengguang <wfg@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
References: <4917263D.2090904@telenet.dn.ua>	<20081110104423.GA26778@kernel.dk>	<x493ahzsn8p.fsf@segfault.boston.devel.redhat.com>	<20081110135618.GI26778@kernel.dk>	<x491vxgkd61.fsf@segfault.boston.devel.redhat.com>	<20081112190227.GS26778@kernel.dk> <1226566313.199910.29888@de>	<20081113085439.GZ26778@kernel.dk> <1226626590.681364.9398@de>	<492BDB55.3050407@vlnb.net> <x498wr7de6u.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x498wr7de6u.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/GBMlKzXdsiV3UEC4MVhEuj+M50PGQC5O7YzU
 87nHJx398TXjCnoagbuRNS/EElXwqwr43bZw0pwdJzgjcncjhU
 FSBV9EU55tsPowkFgqJNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer wrote:
> Vladislav Bolkhovitin <vst@vlnb.net> writes:
> 
>> Wu Fengguang wrote:
>>> Another scheme is to detect the sequential pattern via looking up
>>> the page cache, which provides one single and consistent view of the
>>> pages recently accessed. That makes sequential detection possible.
>>>
>>> The cost will be one extra page cache lookup per random read.
>>> If it's not acceptable, the corresponding code could be disabled
>>> by default. 
>> I think, this should be the best and the simplest way to go. Since in
>> most case data from the cache should be later copied to user, one more
>> page cache lookup should be negligible.
> 
> I haven't thought about your suggestion in any detail, but it seems to
> me that you will not handle O_DIRECT I/O with this scheme.

And shouldn't. One using O_DIRECT is supposed to understand and accept 
that no features provided by page cache, including read ahead, will be 
available to him. Hence, if necessary, he must implement own read ahead 
procedures.

> Cheers,
> Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbYKYPVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbYKYPVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYKYPVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:21:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46591 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbYKYPV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:21:29 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Wu Fengguang <wfg@linux.intel.com>, Jens Axboe <jens.axboe@oracle.com>,
       "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
References: <4917263D.2090904@telenet.dn.ua>
	<20081110104423.GA26778@kernel.dk>
	<x493ahzsn8p.fsf@segfault.boston.devel.redhat.com>
	<20081110135618.GI26778@kernel.dk>
	<x491vxgkd61.fsf@segfault.boston.devel.redhat.com>
	<20081112190227.GS26778@kernel.dk> <1226566313.199910.29888@de>
	<20081113085439.GZ26778@kernel.dk> <1226626590.681364.9398@de>
	<492BDB55.3050407@vlnb.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 25 Nov 2008 10:21:13 -0500
In-Reply-To: <492BDB55.3050407@vlnb.net> (Vladislav Bolkhovitin's message of
	"Tue, 25 Nov 2008 14:02:45 +0300")
Message-ID: <x498wr7de6u.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladislav Bolkhovitin <vst@vlnb.net> writes:

> Wu Fengguang wrote:
>> Another scheme is to detect the sequential pattern via looking up
>> the page cache, which provides one single and consistent view of the
>> pages recently accessed. That makes sequential detection possible.
>>
>> The cost will be one extra page cache lookup per random read.
>> If it's not acceptable, the corresponding code could be disabled
>> by default. 
>
> I think, this should be the best and the simplest way to go. Since in
> most case data from the cache should be later copied to user, one more
> page cache lookup should be negligible.

I haven't thought about your suggestion in any detail, but it seems to
me that you will not handle O_DIRECT I/O with this scheme.

Cheers,
Jeff

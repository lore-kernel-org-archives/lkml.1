Return-Path: <linux-kernel-owner+w=401wt.eu-S1759654AbZELAye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654AbZELAye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbZELAyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:54:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:33715 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbZELAyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:54:21 -0400
Message-ID: <4A08C871.9000100@kernel.org>
Date: Tue, 12 May 2009 09:53:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Konrad Rzeszutek <konrad@virtualiron.com>
CC: device-mapper development <dm-devel@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>, jeff@garzik.org,
       linux-scsi@vger.kernel.org, Mauelshagen@redhat.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jens.axboe@oracle.com, martin.petersen@oracle.com
Subject: Re: [dm-devel] Re: [PATCH 1/3] block: add alt_size
References: <1241828002-12742-1-git-send-email-tj@kernel.org> <1241828002-12742-2-git-send-email-tj@kernel.org> <ac3eb2510905090645u5e482ffcu4b3ddc26e81247e6@mail.gmail.com> <4A058D5C.6030206@kernel.org> <20090511134534.GA32678@mars.virtualiron.com>
In-Reply-To: <20090511134534.GA32678@mars.virtualiron.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 00:53:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek wrote:
> .. snip ..
>>> Also, values with magic block counts, while there is no way to get the
>>> blocksize with the same interface, are pretty weird. I think the
>>> current "size" attribute is just a bug.
>> Logical block size is fixed at 512 bytes.  Offset and size are always
>> represented in multiples of 512 bytes and only get converted to
>> hardware block size in the lld.
> 
> That interpretation is at odds with the work that Martin Peterson is
> doing with the 4K support. In the e-mail titled: "Re: [PATCH 4 of 8] sd:
> Physical block size and alignment support",
> Message-ID:<yq1ab67b51p.fsf@sermon.lab.mkp.net> he says:
> 
> "
> 	Konrad> about what a 'logical block', and 'physical block' is
> 	Konrad> vs. 'hardware sector' ?
> 
> 	Well, another item on my todo list is to kill the notion of hardware
> 	sector completely.  The protocols have been referring to logical blocks
> 	for ages.
> 
> 	It hasn't been a big problem until now because logical block size has
> 	been equal to the hardware sector size.  That's no longer a valid
> 	assumption.
> "
> 
> Are the ATA/SCSI/etc specs at odds with each other about this?

Hardware specs aren't of concern here.  The logical block concept is
there simply to give 9 bit addressing advantage, nothing more, nothing
less.  If hardware's sector size doesn't match it, the lld should be
mapping the sector addresses and sizes and cdrom and a few other
drives have been doing that for ages.  There's nothing new about
devices with sectors larger than 512 bytes.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760873AbYC0S4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873AbYC0S4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 14:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbYC0S4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 14:56:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbYC0S4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 14:56:41 -0400
Message-ID: <47EBED9B.8020706@zytor.com>
Date: Thu, 27 Mar 2008 11:55:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>,
       Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca>	 <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca>	 <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca>	 <20080325192515.GA24234@suse.de> <47E99A02.7040903@rtr.ca> <3ae72650803271151k5a7b5c4cn5078b3bdf6a9c87a@mail.gmail.com>
In-Reply-To: <3ae72650803271151k5a7b5c4cn5078b3bdf6a9c87a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
>>
>>  And it's not just a few 10s of lines of code currently,
>>  but rather about 80-100 lines just to find the correct device subdir,
>>  and *then* a few more 10s of lines of code to retrieve the value.
> 
> Hmm, 100 lines? What else do you need?
> 
>   $ grep -l 8:3 /sys/class/block/*/dev
>   /sys/class/block/sdc/dev
> 

That's particularly funny, because your very own example gives the wrong 
result -- sdc is 8:32 not 8:3 (which is sdc3, which is also excluded by 
your search.)

Not to mention the fact that it is still O(n).

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbYC0Tk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbYC0Tk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbYC0TkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:40:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58895 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbYC0TkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:40:14 -0400
Message-ID: <47EBF7D0.6000901@zytor.com>
Date: Thu, 27 Mar 2008 12:38:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Tejun Heo <htejun@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Greg KH <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>,
       Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca>	 <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca>	 <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca>	 <20080325192515.GA24234@suse.de> <47E99A02.7040903@rtr.ca>	 <47E99EBE.7010708@gmail.com> <3ae72650803271229h6e188de1t81ccfb64e5d3a214@mail.gmail.com>
In-Reply-To: <3ae72650803271229h6e188de1t81ccfb64e5d3a214@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
>>
>>  Probably something like /sys/class/block/MAJ:MIN
> 
> "Devices directories" are not supposed to contain duplicate entries.
> It would slow-down, or may even break things.
> 
>> or /sys/class/devnums/bMAJ:MIN?
> 
> These are no devices belonging to the class "devnums", so it may
> confuse things which crawl these directories to get "all devices".
> Current coldplug-like setups will likely add duplicate devices with
> the wrong subsystem. There are also bus-devices with have a dev_t, and
> that will make them show up in /sys/class, which might confuse some
> tools too.
> 
> I guess we will need to find some other solution as a /sys/class/ for
> that. And we must prefix the links with 'c' and 'b' because dev_t is
> not unique across char and block devices.
> 

It doesn't really seem to be to belong under class at all.  I would 
suggest /sys/dev/char/ and /sys/dev/block/, for char and block respectively.

	-hpa


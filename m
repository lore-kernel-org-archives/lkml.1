Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbZDMJJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbZDMJJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 05:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZDMJJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 05:09:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60685 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbZDMJJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 05:09:10 -0400
Message-ID: <49E30131.2020408@garzik.org>
Date: Mon, 13 Apr 2009 05:09:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sata_sx4: refresh and convert to new EH
References: <20090408200511.GA24071@havoc.gtf.org>	 <a4423d670904111946w2a8f3839n27b77f5473076563@mail.gmail.com>	 <49E1CE26.9050401@garzik.org> <a4423d670904121923l391d67cake297c5a71ca49ace@mail.gmail.com>
In-Reply-To: <a4423d670904121923l391d67cake297c5a71ca49ace@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov wrote:
> 2009/4/12 Jeff Garzik <jeff@garzik.org>:
>> Alexander Beregalov wrote:
>>> 2009/4/9 Jeff Garzik <jeff@garzik.org>:
>>>> I reviewed and refreshed libata-dev.git#new-eh, now renamed to #sx4.
>>>>
>>>> Several bugs and missing pieces in the new-EH conversion were addressed
>>>> (often by copying highly similar code from sata_promise, a highly
>>>> similar chip)
>>>>
>>>> The only thing left is some "it still works" testing...  any takers?
>>>>
>>> Hi Jeff
>>>
>>> I have SX4000 card, it is based on the same PDC20621 chip, but has PATA
>>> ports
>>> (without PATA-SATA bridges).
>>> Can I help?
>>>
>>> I am newbie here, but I will try to modify the driver to support PATA
>>> card as well
>>> and test your patch.
>> It's unknown how well, or what is needed, to support the SX4000.  You are
>> welcome to dive in and figure out what is needed, but you'd be asking
>> questions to which we wouldn't have answers.
> 
> I found Promise provided docs for FreeBSD team.
> http://unix.derkeiler.com/Mailing-Lists/FreeBSD/performance/2003-07/0043.html

Well, you can find several docs at 
http://gkernel.sourceforge.net/specs/promise/


>> I do have the sx4000 in the works (thanks to Promise who has provided docs
>> and HW to make this happen)..
> Can we ask them too? :)
> 
> Interesting, I cut off all unrelated lines from freebsd/ata/ata-chipset.c
> and it seems SX4/SX4000 driver is only about 700 lines long.

The current FreeBSD has split up things into multiple files.  You can 
check out the kernel via

	cd $repo
	mkdir -p freebsd/src
	cd freebsd
	svn checkout svn://svn.freebsd.org/base/head/sys src/sys
	cd src/sys/dev/ata/chipsets

and indeed ata-promise.c has plenty of SX4[000] goodies to mess around with!

Also, check out this stuff from sata_promise maintainer Mikael:
http://marc.info/?l=linux-ide&m=121144512109826&w=2
http://marc.info/?l=linux-ide&m=121135828227724&w=2

My revised sata_sx4.c is currently stored on the "sx4" branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

	Jeff




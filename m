Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZJ1Uqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZJ1Uqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbZJ1Uqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:46:54 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:41697 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbZJ1Uqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:46:53 -0400
Date: Wed, 28 Oct 2009 14:46:57 -0600
From: Alex Chiang <achiang@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091028204657.GB8749@ldl.fc.hp.com>
References: <4AD34494.7020602@rtr.ca> <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <20091027024841.GA30509@ldl.fc.hp.com> <20091027082635.GS10727@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027082635.GS10727@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe <jens.axboe@oracle.com>:
> 
> acpiphp: enable_slot - physical_slot = 1
> power_on_slot
>   no _PS0
>   no _PS0
>   no _PS0
>   no _PS0
>   no _PS0
>   no _PS0
>   no _PS0
>   no _PS0
> get_slot_status
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
>   reading config space dvid 0xffffffff
> acpiphp_glue: acpiphp_enable_slot: Slot status is not ACPI_STA_ALL

Hm, as Kenji-san writes in an earlier email:

	The direct cause of the problem that your slot was not
	turned on is power fault. I guess acpiphp is suffering
	the same problem.  Unfortunately, it's difficult for me
	to analyze the root cause of this power fault. Please ask
	the hardware vendor about it. I hope board replacement
	will fix the problem.

In get_slot_status(), we're trying to read the card's vendor ID,
which is a mandatory PCI config space register. The fact that we
can't even read that suggests something is going wrong way
earlier before we get to this point.

Bjorn wondered on irc if your slots are physically working. Do
you know if they work under Windows? If they do, then it would be
good to find out how your bridges are being programmed, which I
believe you can discover with the Device Manager.

/ac

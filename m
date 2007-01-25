Return-Path: <linux-kernel-owner+w=401wt.eu-S1030575AbXAYVVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030575AbXAYVVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030577AbXAYVVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:21:51 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:5526 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030575AbXAYVVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:21:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DL1J0gm/HiChox0Xztc7LMZDY1Q9vE71vMwP79JtUOJcLC5KDeE8SOYxAqYoEvsXO1RJ0v0k41IjekcKXROctqPhdIMkCHVTgYcwW/LpE1yU+3kramSr3WwEEVECNmYfe6zl0Jk969o/kd2JpK8Dme2MZF8VFOnsgtXvIDjIbXs=
Message-ID: <311601c90701251321s58c8c0e2s9050fbf9c41cabad@mail.gmail.com>
Date: Thu, 25 Jan 2007 14:21:48 -0700
From: "Eric D. Mudama" <edmudama@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: SATA hotplug from the user side ?
Cc: "Soeren Sonnenburg" <kernel@nn7.de>, "Tejun Heo" <htejun@gmail.com>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070124153727.GC15402@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1168639639.3707.6.camel@localhost>
	 <1168672966.3707.24.camel@localhost> <45AAE52B.2070705@gmail.com>
	 <1169456682.2901.18.camel@localhost>
	 <20070122210312.GD4516@khazad-dum.debian.net>
	 <45B5A9C7.5050700@gmail.com>
	 <20070123131040.GB13467@khazad-dum.debian.net>
	 <45B6BF5D.1070300@gmail.com> <1169629789.3779.3.camel@localhost>
	 <20070124153727.GC15402@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> Tejun, is it feasible to teach libata to check the device power management
> state before issuing any of the sleep, head unload and spin-down commands?
>
> libata would need to block its EH from resetting a channel for this check
> operation (we don't want to wake up sleeping devices to ask it if it is
> sleeping...) if it cannot easily check if an device is asleep before issuing
> a command to it.   Either that, or (for as long as there is no such a thing
> as a multi-initiator libata device) just keep track of the device power
> management state by snooping all the commands sent to it.

In the ATA spec, the CHECK POWER MODE command (E5h) specifically
states that it shouldn't alter the power mode of the device.
Therefore, there should be no harm in checking the power mode of a
device in STANDBY or IDLE state, and it shouldn't cause the device to
spin up.  Checking a drive on my bench I confirmed this behavior.

With Serial ATA you have to consider the SATA bus PM states as well,
but that's a different topic of discussion.

--eric

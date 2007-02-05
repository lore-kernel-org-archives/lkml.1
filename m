Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbXBELuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbXBELuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 06:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbXBELuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 06:50:39 -0500
Received: from nz-out-0506.google.com ([64.233.162.238]:59474 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbXBELui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 06:50:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=r7m22r03IcpI9BBl3wewy3A3F/pTsESyQkASabmHhusuEYB7vECQFyzXyQ2xlnMjEnw3m/x4Io3KbeIpUcIYhomMK2tS4lDIq6ZgmDGWgMD0eP1oPKmXMRmfTxdinmMQREHANSn6TnFudYqdZd9vEIa8kfWlzH7eUeZand8BYMw=
Message-ID: <45C71A07.1030906@gmail.com>
Date: Mon, 05 Feb 2007 20:50:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Soeren Sonnenburg <kernel@nn7.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SATA hotplug from the user side ?
References: <1168639639.3707.6.camel@localhost> <45A83C22.6050409@gmail.com> <1168672966.3707.24.camel@localhost> <45AAE52B.2070705@gmail.com> <1169456682.2901.18.camel@localhost> <20070122210312.GD4516@khazad-dum.debian.net> <45B5A9C7.5050700@gmail.com> <20070123131040.GB13467@khazad-dum.debian.net> <45B6BF5D.1070300@gmail.com> <1169629789.3779.3.camel@localhost> <20070124153727.GC15402@khazad-dum.debian.net>
In-Reply-To: <20070124153727.GC15402@khazad-dum.debian.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Henrique, sorry about being late.

Henrique de Moraes Holschuh wrote:
> Tejun, is it feasible to teach libata to check the device power management
> state before issuing any of the sleep, head unload and spin-down commands?
> 
> libata would need to block its EH from resetting a channel for this check
> operation (we don't want to wake up sleeping devices to ask it if it is
> sleeping...) if it cannot easily check if an device is asleep before issuing
> a command to it.   Either that, or (for as long as there is no such a thing
> as a multi-initiator libata device) just keep track of the device power
> management state by snooping all the commands sent to it.
> 
> The idea would be to do the "optimal" thing if one tries to sleep, unload
> heads or spin down an device that is already doing one of these things...
> That would make things MUCH easier on userspace.

For that to be meaningful, the premise is that ATA drives spin up to
process STANDBY IMMEDIATE when it's in Standby state.  The spec doesn't
exactly specify what happens on when STANDBY IMMEDIATE is received while
in Standby state other than it exits to Active iff Media access is required.

I've tested several drivers from different vendors and none of them
seems to spin up when they receive FLUSH and STANDBY IMMEDIATE while
they're in Standby mode.  They just ack that the command is complete and
stay spun down.  Do you have drives which act differently?

So, if most of drives act that way, whether both or anyone of them are
being done just doesn't matter as long as at least one gets done.

Thanks.

-- 
tejun

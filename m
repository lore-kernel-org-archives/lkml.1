Return-Path: <linux-kernel-owner+w=401wt.eu-S932525AbZLDXee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbZLDXee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbZLDXed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:34:33 -0500
Received: from outbound-mail-15.bluehost.com ([69.89.18.115]:60664 "HELO
	outbound-mail-15.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757410AbZLDXec convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:34:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mCX+2f24end3tAFs7sLdbOE+lQhDMAU6KBGrdMkNXodwSJCC94m/GNOz9feXZHGmUHO/seVaSv6sOeInpnN2JPpdU0XDGzmNMrZsZGMN4AWxE0GTZxh4+MJ8hJB8543f;
Date: Fri, 4 Dec 2009 15:33:51 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Stephane GONAUER" <stephane.gonauer@sofrelog.com>
Cc: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <achiang@hp.com>, <kaneshige.kenji@jp.fujitsu.com>,
       <David.Woodhouse@intel.com>
Subject: Re: PCIexpress Slot_Power_Limit and Power budgetting.
Message-ID: <20091204153351.3752feea@jbarnes-piketon>
In-Reply-To: <001401ca6901$f9c03ed0$ed40bc70$@gonauer@sofrelog.com>
References: <001401ca6901$f9c03ed0$ed40bc70$@gonauer@sofrelog.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009 11:20:50 +0100
"Stephane GONAUER" <stephane.gonauer@sofrelog.com> wrote:
> I am a embedded system designer and currently working on the
> preliminary design of a PCIepress expansion board to be used on x86
> motherboard.
> 
> My board is to be an x1 PCie board. Thus according to the PCIe
> electromechanical specifications,  the board may consume 10Watts by
> default, and 25Watts after correct dialog is established with upper
> bridges and the root complex. (which after acknowledging the request
> should send a Slot_Power_Limit message to the board to allow for
> higher power consumption).
> 
> The board is based on a PEX8311 PCIe to local bus chip from PLX tech.
> This component is able to present its request for more power using
> the power budgeting capability as defined by the PCIe standard.
> 
> However this doesn’t seems to have effect on the system (running
> latest ubuntu with 2.6.31 kernel) and from my understanding of the
> kernel sources this is not supported. Is that correct ?
> 
> Are there ways that I’m not aware to request for more power in the
> existing source base ?

Not in PCIe that I'm aware of, aside from the existing ASPM support,
but that's a bit different.

> I’ve been reading the PCIE-port driver source to try to find a way to
> achieve my goal. My understanding is that this driver is very generic
> and as such shouldn’t be able to support power budgeting. I believe
> adding Power budgeting to it would require to match more closely the
> motherboard hardware. Am I correct ?

Yeah, we'd need to get power budget info from the firmware or platform
somehow, which means we'd have to add a platform specific portion to
the PCIe port driver, or at the very least some basic power
initialization routines that could be called from platform specific
code.

> Perhaps you have better ideas on the subject than me.
> 
> I’d be very glad if I could get some comments on this issue. I hope I
> haven’t been writing to the wrong people.

Given how long it's taken me to reply, maybe you have an implementation
already. :)

We'd definitely be interested in adding such a feature if your platform
supports it and has need of it.

-- 
Jesse Barnes, Intel Open Source Technology Center

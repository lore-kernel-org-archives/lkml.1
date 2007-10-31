Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbXJaQa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbXJaQa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXJaQat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:30:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:24987 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbXJaQas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:30:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=rIxKWz+Bxi3Qa45SWI9w4bTzIHCM4MttqEGTJz35uzQYLrTFT+0I0okWWyuTKG//OOp82hR2dsxr1SdrRC47JibXKxOTpSiCzTlcT5sAOlRncrmdTEci8ZNgHbFCH84F67TnfVh3oRdG+j33xUVclHD/WiFPbukS3jRmmh9lOo4=
Message-ID: <4728ADAF.7050607@googlemail.com>
Date: Wed, 31 Oct 2007 17:30:39 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Domen Puncer <domen.puncer@telargo.com>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FEC_MPC52xx_MDIO oddness.
References: <20071031142212.GA792@redhat.com> <20071031150619.GO3369@nd47.coderock.org>
In-Reply-To: <20071031150619.GO3369@nd47.coderock.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Domen Puncer wrote:
> On 31/10/07 10:22 -0400, Dave Jones wrote:
>> The Kconfig for this reads..
>>
>> +config FEC_MPC52xx_MDIO
>> +       bool "MPC52xx FEC MDIO bus driver"
>> +       depends on FEC_MPC52xx
>> +       default y
>> +       ---help---
>> +         The MPC5200's FEC can connect to the Ethernet either with
>> +         an external MII PHY chip or 10 Mbps 7-wire interface
>> +         (Motorola? industry standard).
>> +         If your board uses an external PHY connected to FEC, enable this.
>> +         If not sure, enable.
>> +         If compiled as module, it will be called 'fec_mpc52xx_phy.ko'.
>>
>> Because this is bool, it'll never be compiled as a module.
>> Given that fec_mpc52xx_phy.c has a MODULE_LICENSE()
>> Should this be a tristate perhaps ?
> 
> It's ok, it will be compiled as module if fec driver is compiled as
> module, and built-in if fec is built-in.
> 
> from Makefile:
> obj-$(CONFIG_FEC_MPC52xx) += fec_mpc52xx.o
> ifeq ($(CONFIG_FEC_MPC52xx_MDIO),y)
>         obj-$(CONFIG_FEC_MPC52xx) += fec_mpc52xx_phy.o
> endif
> 
> Yes, a bit weird, but it's best I could come up with.
> (fec_mdio=m and fec=y is an invalid case, that I wanted to avoid).

Could you please fix this warnings as well ?


http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/13c9d93a7afa60e2

Regards,

Gabriel



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbXLYOda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbXLYOda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 09:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXLYOdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 09:33:21 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:41640 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbXLYOdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 09:33:20 -0500
Date: Tue, 25 Dec 2007 15:32:41 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alon Bar-Lev <alon.barlev@gmail.com>, linux-mips@ftp.linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [MIPS] MEM_SDREFCFG is not defined for Alchemy DB1550 (compile
	fail)
Message-ID: <20071225143240.GA29231@linux-mips.org>
References: <9e0cf0bf0712230733o3dfd54fcp4962ebf3f84cdff@mail.gmail.com> <4770DE51.5000205@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4770DE51.5000205@ru.mvista.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2007 at 01:41:21PM +0300, Sergei Shtylyov wrote:

>> When I have:
>> CONFIG_MIPS_DB1550
>> CONFIG_SOC_AU1550
>> CONFIG_SOC_AU1X00
>> CONFIG_PM
>
>> MEM_SDREFCFG is used at:
>> arch/mips/au1000/common/power.c::pm_do_freq()
>
>    PM code is generally broken and unmaintained, so no wonder. I don't 
> remember if anyone has fixed CPU context restoration code (it uses a 
> "skewed" stack frame).
>
>> While the MEM_SDREFCFG constant is declare only for CONFIG_SOC_AU1000,
>> CONFIG_SOC_AU1500, CONFIG_SOC_AU1100 at:
>> include/asm-mips/mach-au1x00/au1000.h
>
>> Maybe MEM_SDREFCFG should be defined for CONFIG_SOC_AU1X00?
>
>    I've just looked into the Au1550 datasheet and indeed it doesn't have 
> such register; its SDDRAM controller is not compatible with older SoCs.
>
>> Or there should be #ifdef for its usage in power.c?
>
>    Looks like you'll have to invent something... ;-)
>
>> Best Regards,
>> Alon Bar-Lev.

So I guess it's time to mark the whole PM stuff as BROKEN?

  Ralf

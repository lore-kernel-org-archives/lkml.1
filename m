Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbZBKWAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbZBKWAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbZBKWAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:00:37 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:12566 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbZBKWAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:00:37 -0500
MIME-Version: 1.0
In-Reply-To: <86802c440902102105w332e496h412733437ca4352d@mail.gmail.com>
References: <1233765552.16414.6.camel@localhost.localdomain>
	 <86802c440902041212q51f2a444l84e1ac29ee6f702e@mail.gmail.com>
	 <20090204212517.GM22608@elte.hu> <498A206A.2070309@kernel.org>
	 <4990DF7C.1090701@kernel.org> <4990DFBA.1050401@kernel.org>
	 <9ae48b020902101457o575f8eb0qa72120efea521c46@mail.gmail.com>
	 <86802c440902102105w332e496h412733437ca4352d@mail.gmail.com>
Date: Wed, 11 Feb 2009 14:00:35 -0800
Message-ID: <9ae48b020902111400pa9bc287s12dbbb38bad9866d@mail.gmail.com>
Subject: Re: Subject: [PATCH] x86/pci: Detect mmconfig on nVidia MCP55 -v2
From: Ed Swierk <eswierk@aristanetworks.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: jbarnes@virtuousgeek.org, Ingo Molnar <mingo@elte.hu>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 9:05 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> try to make thing simple.
> for system: with AMD Fam10h, and MCP55 + 2 IO55
> amd fam10h cpu: said it needs [0,0]
> mcp55: said it need [0,255]
> io55 #1: said it need [0x40, 0x40+255], then u8 end_bus_number = 0x3f
> io55 #2: said it need [0x80, 0x80+255], then u8 end_bus_number = 0x7f
> MMIO route in NBs is right.

Oh, I misinterpreted your earlier comment--I thought you were
referring to 0x40, 0x80, 0xc0 as devfns, not bus numbers. The MCP55 is
on device 0 on our board as well.

> but MCFG is right... so just use that.
>
> when acpi=off, if check_and_enable_amd_mconf, it will forcely to make
> amd fam10h cpu: said it needs [0,255] and pci_mmcfg_config_num = 1
> so mcp55 mconf is not used.

OK, I'm just pointing out that the existing mmconfig hostbridge
detection code overrides ACPI MCFG. Past commit comments suggest that
the hostbridge registers are more trustworthy than ACPI on some
boards.

--Ed

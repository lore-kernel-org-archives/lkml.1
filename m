Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbXCJTbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbXCJTbU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 14:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbXCJTbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 14:31:19 -0500
Received: from smtp-106-saturday.noc.nerim.net ([62.4.17.106]:4704 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932073AbXCJTbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 14:31:17 -0500
Date: Sat, 10 Mar 2007 20:29:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Petr Vandrovec <petr@vandrovec.name>
Cc: i2c@lm-sensors.org, Hans-Frieder Vogt <hfvogt@gmx.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nForce MCP61 support to i2c-nforce2
Message-Id: <20070310202941.165b28a0.khali@linux-fr.org>
In-Reply-To: <20070310080003.GA24177@vana.vc.cvut.cz>
References: <20070310080003.GA24177@vana.vc.cvut.cz>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Petr,

On Sat, 10 Mar 2007 09:00:03 +0100, Petr Vandrovec wrote:
> Hello,
>   patch below adds support for nVidia's SMBus adapter present on Gateway's GT5414E 
> motherboard (ECS's MCP61 PM-AM).  Patch is for current Linus's git tree.

We already have a patch doing exactly this in -mm:
http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm2/broken-out/jdelvare-i2c-i2c-nforce2-add-mcp61-mcp65-support.patch

> 00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)
>         Subsystem: Elitegroup Computer Systems Unknown device 2601
>         Flags: 66MHz, fast devsel, IRQ 10
>         I/O ports at fc00 [size=64]
>         I/O ports at 1c00 [size=64]
>         I/O ports at f400 [size=64]
>         Capabilities: [44] Power Management version 2

BTW, note how the MCP61 has not 2 but 3 64-byte I/O areas declared. The
previous chips used BAR 4 and 5, this new one additionally uses BAR 0.
Without documentation it's hard to be sure this is a 3rd SMBus channel,
but it sure looks so. Maybe you'll want to hack the i2c-nforce2 driver
a bit to confirm or infirm this theory.

-- 
Jean Delvare

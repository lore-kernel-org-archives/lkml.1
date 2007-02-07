Return-Path: <linux-kernel-owner+w=401wt.eu-S965656AbXBGG6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656AbXBGG6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 01:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965653AbXBGG6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 01:58:12 -0500
Received: from colo.lackof.org ([198.49.126.79]:58029 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965656AbXBGG6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 01:58:11 -0500
Date: Tue, 6 Feb 2007 23:58:03 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, greg@kroah.com
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Message-ID: <20070207065803.GA15076@colo.lackof.org>
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com> <20070206045528.GA4228@colo.lackof.org> <20070206050331.GB4228@colo.lackof.org> <20070205213339.80239a22.akpm@linux-foundation.org> <20070206084638.GB20752@colo.lackof.org> <1a297b360702060313n34a8f941oebf9f373630b070f@mail.gmail.com> <1a297b360702060352y3faa0f46i7c4a01499fae2eff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a297b360702060352y3faa0f46i7c4a01499fae2eff@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 03:52:47PM +0400, Manu Abraham wrote:
> >attaching a dump of the regs (on 2.6.17.7) as well as the diff
> 
> The device now works, used the demodulator driver alongwith the bridge 
> driver.

Ok - thanks for the dmesg output and log. I suspect you've already
tried cycling power on the machine (If not, please do).
I have no idea what M$ XP was doing that might "fix" the problem.

I was just suspicious of our byte accesses to the same dword.
To answer you previous question, it's possible that M$ only
uses dword accesses. I don't know.

> inlined the log

excellent - sounds like you are making forward progress even
if we can not reproduce the problem...worst case other users
(or customers) have a "work around" :^/

thanks,
grant

ps. I'll be unavailable until this weekend when I want to look at
the old and new logs a bit more.

> 
> regards,
> manu
> 
> 
> [17181623.040000] gpif status: 6000  irqcfg: 0000
> [17181623.040000] irq: 18, latency: 64
> [17181623.040000]  memory: 0xefeff000, mmio: 0xe18f4000
> [17181623.040000] found a UNKNOWN PCI UNKNOWN device on (02:0a.0),
> [17181623.040000]     Mantis Rev 1 [1822:0031], irq: 18, latency: 64
> [17181623.040000]     memory: 0xefeff000, mmio: 0xe18f4000
> [17181623.040000]         mantis_i2c_write: Address=[0x50] <W>[ 08 ]
> [17181623.040000]         mantis_i2c_read:  Address=[0x50] <R>[ 00 00
> 00 00 00 00 ]
> [17181623.044000]     MAC Address=[00:00:00:00:00:00]
> [17181623.044000] mantis_alloc_buffers (0): DMA=0x186b0000
> cpu=0xd86b0000 size=65536
> [17181623.044000] mantis_alloc_buffers (0): RISC=0x1c3af000
> cpu=0xdc3af000 size=1000
> [17181623.044000] DVB: registering new adapter (Mantis dvb adapter).
> [17181623.564000] mantis_frontend_init (0): Probing for STB0899
> (DVB-S/DSS/DVB-S2)
> [17181623.564000] stb0899_write_regs [0xf1b6]: 02
> [17181623.564000]         mantis_i2c_write: Address=[0x68] <W>[ f1 b6 02 ]
> [17181623.564000] stb0899_write_regs [0xf1c2]: 00
> [17181623.564000]         mantis_i2c_write: Address=[0x68] <W>[ f1 c2 00 ]
> [17181623.568000] stb0899_write_regs [0xf1c3]: 00
> [17181623.568000]         mantis_i2c_write: Address=[0x68] <W>[ f1 c3 00 ]
> [17181623.568000]         mantis_i2c_write: Address=[0x68] <W>[ f0 00 ]
> [17181623.568000]         mantis_i2c_read:  Address=[0x68] <R>[ 82 ]
> [17181623.568000] stb0899_read_reg: Reg=[0xf000], data=82
> [17181623.568000] stb0899_get_dev_id: Device ID=[8], Release=[2]
> [17181623.568000]         mantis_i2c_write: Address=[0x68] <W>[ f3 fc
> 00 04 00 00 ]
> [17181623.572000]         mantis_i2c_write: Address=[0x68] <W>[ f3 34 ]
> [17181623.572000]         mantis_i2c_read:  Address=[0x68] <R>[ 31 44 4d 44 
> ]
> [17181623.572000]         mantis_i2c_write: Address=[0x68] <W>[ f3 34 ]
> [17181623.572000]         mantis_i2c_read:  Address=[0x68] <R>[ 31 44 4d 44 
> ]
> [17181623.576000] stb0899_read_s2reg Device=[0xf3fc], Base
> address=[0x00000400], Offset=[0xf334], Data=[0x444d4431]
> [17181623.576000]         mantis_i2c_write: Address=[0x68] <W>[ f3 fc
> 00 04 00 00 ]
> [17181623.576000]         mantis_i2c_write: Address=[0x68] <W>[ f3 00 ]
> [17181623.576000]         mantis_i2c_read:  Address=[0x68] <R>[ 01 00 00 00 
> ]
> [17181623.580000]         mantis_i2c_write: Address=[0x68] <W>[ f3 3c ]
> [17181623.580000]         mantis_i2c_read:  Address=[0x68] <R>[ 01 00 00 00 
> ]
> [17181623.580000] stb0899_read_s2reg Device=[0xf3fc], Base
> address=[0x00000400], Offset=[0xf33c], Data=[0x00000001]
> [17181623.580000] stb0899_get_dev_id: Demodulator Core ID=[DMD1], 
> Version=[1]
> [17181623.580000]         mantis_i2c_write: Address=[0x68] <W>[ fa fc
> 00 08 00 00 ]
> [17181623.584000]         mantis_i2c_write: Address=[0x68] <W>[ fa 00 ]
> [17181623.584000]         mantis_i2c_read:  Address=[0x68] <R>[ 4c 00 00 00 
> ]
> [17181623.588000]         mantis_i2c_write: Address=[0x68] <W>[ fa 2c ]
> [17181623.588000]         mantis_i2c_read:  Address=[0x68] <R>[ 31 43 45 46 
> ]
> [17181623.588000] stb0899_read_s2reg Device=[0xfafc], Base
> address=[0x00000800], Offset=[0xfa2c], Data=[0x46454331]
> [17181623.588000]         mantis_i2c_write: Address=[0x68] <W>[ fa fc
> 00 08 00 00 ]
> [17181623.592000]         mantis_i2c_write: Address=[0x68] <W>[ fa 34 ]
> [17181623.592000]         mantis_i2c_read:  Address=[0x68] <R>[ 01 00 00 00 
> ]
> [17181623.592000]         mantis_i2c_write: Address=[0x68] <W>[ fa 34 ]
> [17181623.592000]         mantis_i2c_read:  Address=[0x68] <R>[ 01 00 00 00 
> ]
> [17181623.596000] stb0899_read_s2reg Device=[0xfafc], Base
> address=[0x00000800], Offset=[0xfa34], Data=[0x00000001]
> [17181623.596000] stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]
> [17181623.596000] stb0899_attach: Attaching STB0899
> [17181623.596000] mantis_frontend_init (0): found STB0899
> DVB-S/DSS/DVB-S2 frontend @0x68
> [17181623.596000] mantis_frontend_init (0): Probing for STB6100 tuner
> [17181623.596000] stb6100_attach: Attaching
> [17181623.596000] mantis_frontend_init (0): found STB6100 tuner @0x60
> [17181623.596000] mantis_frontend_init (0): Probing for LNBP21 SEC
> [17181623.596000]         mantis_i2c_write: Address=[0x08] <W>[ 40 ]
> [17181623.596000] DVB: registering frontend 0 (STB0899 Multistandard)...

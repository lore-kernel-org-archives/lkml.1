Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbXIQPaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbXIQPaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 11:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbXIQPaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 11:30:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60486 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbXIQPaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 11:30:08 -0400
Message-ID: <46EE9D66.1030705@zytor.com>
Date: Mon, 17 Sep 2007 08:29:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC -mm 2/2] i386/x86_64 boot: document for 32 bit boot protocol
References: <1190017582.5866.22.camel@caritas-dev.intel.com>
In-Reply-To: <1190017582.5866.22.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> This patch defines a 32-bit boot protocol and adds corresponding
> document.
> +
> +In addition to read/modify/write kernel header of the zero page as
> +that of 16-bit boot protocol, the boot loader should fill the
> +following additional fields of the zero page too.
> +
> +Offset	Type		Description
> +------  ----		-----------
> +    0	32 bytes	struct screen_info, SCREEN_INFO
> +			ATTENTION, overlaps the following !!!
> +    2	unsigned short	EXT_MEM_K, extended memory size in Kb (from int 0x15)
> + 0x20	unsigned short	CL_MAGIC, commandline magic number (=0xA33F)
> + 0x22	unsigned short	CL_OFFSET, commandline offset
> +			Address of commandline is calculated:
> +			  0x90000 + contents of CL_OFFSET
> +			(only taken, when CL_MAGIC = 0xA33F)
> + 0x40	20 bytes	struct apm_bios_info, APM_BIOS_INFO
> + 0x60	16 bytes	Intel SpeedStep (IST) BIOS support information
> + 0x80	16 bytes	hd0-disk-parameter from intvector 0x41
> + 0x90	16 bytes	hd1-disk-parameter from intvector 0x46
> +
> + 0xa0	16 bytes	System description table truncated to 16 bytes.
> +			( struct sys_desc_table_struct )
> + 0xb0 - 0x13f		Free. Add more parameters here if you really need them.
> + 0x140- 0x1be		EDID_INFO Video mode setup
> +
> +0x1c4	unsigned long	EFI system table pointer
> +0x1c8	unsigned long	EFI memory descriptor size
> +0x1cc	unsigned long	EFI memory descriptor version
> +0x1d0	unsigned long	EFI memory descriptor map pointer
> +0x1d4	unsigned long	EFI memory descriptor map size
> +0x1e0	unsigned long	ALT_MEM_K, alternative mem check, in Kb
> +0x1e4	unsigned long	Scratch field for the kernel setup code
> +0x1e8	char		number of entries in E820MAP (below)
> +0x1e9	unsigned char	number of entries in EDDBUF (below)
> +0x1ea	unsigned char	number of entries in EDD_MBR_SIG_BUFFER (below)
> +0x290 - 0x2cf		EDD_MBR_SIG_BUFFER (edd.S)
> +0x2d0 - 0xd00		E820MAP
> +0xd00 - 0xeff		EDDBUF (edd.S) for disk signature read sector
> +0xd00 - 0xeeb		EDDBUF (edd.S) for edd data
> +
> +After loading and setuping the zero page, the boot loader can load the
> +32/64-bit kernel in the same way as that of 16-bit boot protocol.
> +
> +In 32-bit boot protocol, the kernel is started by jumping to the
> +32-bit kernel entry point, which is the start address of loaded
> +32/64-bit kernel.
> +
> +At entry, the CPU must be in 32-bit protected mode with paging
> +disabled; the CS and DS must be 4G flat segments; %esi holds the base
> +address of the "zero page"; %esp, %ebp, %edi should be zero.

This is just replicating the "zero-page.txt" document, which can best be
described as a "total lie" -- compare with the actual structure.

	-hpa

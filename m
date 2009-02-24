Return-Path: <linux-kernel-owner+w=401wt.eu-S1759749AbZBXVNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbZBXVNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757230AbZBXVND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:13:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932AbZBXVNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:13:01 -0500
Message-ID: <49A462BD.7010205@zytor.com>
Date: Tue, 24 Feb 2009 13:12:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Thomas Jourdan <tjourdan@interfaceconcept.com>
CC: linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
       Peter Jones <pjones@redhat.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [BUG] dmi_scan_machine uses uninitialized address on x86 / EFI
References: <342F93DAA55A4EE888FBD256CE6044F4@thje6600v>
In-Reply-To: <342F93DAA55A4EE888FBD256CE6044F4@thje6600v>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Jourdan wrote:
> 
> On x86/EFI platforms, if efi_enabled is true, the dmi_scan_machine function
> fails, even if valid DMI table is present. In the setup_arch function,
> efi_init is called after dmi_scan_machine. But this is efi_init which will
> initialize the smbios address, needed by dmi_scan_machine.
> 
> This leads to dmi_scan_machine ioremapping physical address 0, instead of
> the address provided by the EFI system table. The following patch fixes the
> problem.
> 

Hi Thomas,

What is the concrete manifestation of the bug (i.e. how critical is it?)
 We are late in the 2.6.29-rc cycle, and this patch seems to have some
risk associated with it.

Huang, Peter, Yinghai: any opinions?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


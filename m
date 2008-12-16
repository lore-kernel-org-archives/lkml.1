Return-Path: <linux-kernel-owner+w=401wt.eu-S1760024AbYLPU2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbYLPU2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759589AbYLPU2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:28:08 -0500
Received: from outbound-mail-119.bluehost.com ([69.89.22.19]:59839 "HELO
	outbound-mail-119.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752933AbYLPU2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:28:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=a7bRB4YdLPZUjtlwcStoQ8PfqZmRJUuQ8ncPYSdo7P0fltABPejEBDdqxIK8Djclqt5FzaGYxsanTDUygOXQcsgkcOQ98O5w1Zs4/99GXON9d2k+lfAeXZmuSDXls2db;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: fixup PCI device booleans in sysfs
Date: Tue, 16 Dec 2008 12:28:01 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-pci" <linux-pci@vger.kernel.org>
References: <20081126074808.GE6539@plum> <20081128213041.GW25548@parisc-linux.org> <Pine.LNX.4.58.0811301353070.30153@shell4.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0811301353070.30153@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161228.02429.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 30, 2008 5:10 pm Trent Piepho wrote:
> From d962157b2b36f2c54d147a296921553b4aefcf7b Mon Sep 17 00:00:00 2001
> From: Trent Piepho <xyzzy@speakeasy.org>
> Date: Sun, 30 Nov 2008 16:51:29 -0800
> Subject: [PATCH] PCI: Make settable sysfs attributes more consistent
>
> PCI devices have three settable boolean attributes, enable,
> broken_parity_status, and msi_bus.
>
> The store functions for these would silently interpret "0x01" as false,
> "1llogical" as true, and "true" would be (silently!) ignored and do
> nothing.
>
> This is inconsistent with typical sysfs handling of settable attributes,
> and just plain doesn't make much sense.
>
> So, use strict_strtoul(), which was created for this purpose.  The store
> functions will treat a value of 0 as false, non-zero as true, and return
> -EINVAL for a parse failure.
>
> Additionally, is_enabled_store() and msi_bus_store() return -EPERM if
> CAP_SYS_ADMIN is lacking, rather than silently doing nothing.  This is more
> typical behavior for sysfs attributes that need a capability.
>
> And msi_bus_store() will only print the "forced subordinate bus ..."
> warning if the MSI flag was actually forced to a different value.
>
> Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>

Nice, I dug this out of the big fakephp flame thread.  Looks like a good fix; 
there are probably other sysfs interfaces in the kernel that need similar 
treatment.  This one is in my linux-next branch now.  Hope there aren't many 
scripts out there depending on the broken behavior! :)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center


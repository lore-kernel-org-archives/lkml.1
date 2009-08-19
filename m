Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZHSV0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZHSV0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 17:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZHSV0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 17:26:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223AbZHSV0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 17:26:49 -0400
Date: Wed, 19 Aug 2009 14:26:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       bero@arklinux.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [Bugme-new] [Bug 14003] New: Infinite loop on bootup while
 handling DMAR
Message-Id: <20090819142634.0fc550d1.akpm@linux-foundation.org>
In-Reply-To: <bug-14003-10286@http.bugzilla.kernel.org/>
References: <bug-14003-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Tue, 18 Aug 2009 14:54:22 GMT bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14003
> 
>            Summary: Infinite loop on bootup while handling DMAR

That's a box-killing post-2.6.30 regression.

>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 2.6.31-rc6
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: PCI
>         AssignedTo: drivers_pci@kernel-bugs.osdl.org
>         ReportedBy: bero@arklinux.org
>         Regression: Yes
> 
> 
> Booting 64bit 2.6.31-rc6 on a hp xw4600 results in an infinite loop of
> 
> DMAR:[DMA READ] Request device [ff:1f.7] fault addr fffffffffffff000
> DMAR:[fault reason 255] Unknown
> 
> even with iommu=soft (2.6.30 could boot with iommu=soft, but would result in
> the same error with hardware iommu enabled).
> 
> 2.6.30 reports this about the DMAR ACPI tables:
> 
> ACPI: DMAR 00000000defc247f 00158 (v01 COMPAQ BEARLX38 00000001      00000000)
> DMAR:Host address width 36
> DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed90000
> DMAR:DRHD (flags: 0x00000001)base: 0x00000000fed93000
> DMAR:RMRR base: 0x00000000defd0000 end: 0x00000000defd0fff
> DMAR:RMRR base: 0x00000000defd1000 end: 0x00000000defd1fff
> DMAR:RMRR base: 0x00000000defd2000 end: 0x00000000defd2fff
> DMAR:RMRR base: 0x00000000defd3000 end: 0x00000000defd3fff
> DMAR:RMRR base: 0x00000000defd4000 end: 0x00000000defd4fff
> DMAR:RMRR base: 0x00000000defd5000 end: 0x00000000defd5fff
> DMAR:RMRR base: 0x00000000defd6000 end: 0x00000000defd6fff
> DMAR:RMRR base: 0x00000000defd7000 end: 0x00000000defd7fff
> Not all IO-APIC's listed under remapping hardware
> 
> Device ff:1f.7 doesn't actually exist, lspci -n says
> 
> 00:00.0 0600: 8086:29e0
> 00:01.0 0604: 8086:29e1
> 00:1a.0 0c03: 8086:2937 (rev 02)
> 00:1a.1 0c03: 8086:2938 (rev 02)
> 00:1a.2 0c03: 8086:2939 (rev 02)
> 00:1a.7 0c03: 8086:293c (rev 02)
> 00:1b.0 0403: 8086:293e (rev 02)
> 00:1c.0 0604: 8086:2940 (rev 02)
> 00:1c.4 0604: 8086:2948 (rev 02)
> 00:1c.5 0604: 8086:294a (rev 02)
> 00:1d.0 0c03: 8086:2934 (rev 02)
> 00:1d.1 0c03: 8086:2935 (rev 02)
> 00:1d.2 0c03: 8086:2936 (rev 02)
> 00:1d.7 0c03: 8086:293a (rev 02)
> 00:1e.0 0604: 8086:244e (rev 92)
> 00:1f.0 0601: 8086:2916 (rev 02)
> 00:1f.2 0106: 8086:2922 (rev 02)
> 01:00.0 0300: 1002:7187
> 01:00.1 0380: 1002:71a7
> 10:0b.0 0c00: 11c1:5811 (rev 61)
> 3f:00.0 0200: 14e4:167b (rev 02)
> 


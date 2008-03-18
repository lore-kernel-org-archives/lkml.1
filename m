Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbYCRH2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbYCRH2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 03:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYCRH2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 03:28:11 -0400
Received: from server54.tchmachines.com ([72.9.244.106]:54077 "EHLO
	server54.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbYCRH2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 03:28:10 -0400
Date: Tue, 18 Mar 2008 00:28:02 -0700
From: Ravikiran Thirumalai <kiran@scalemp.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       gcosta@redhat.com, mingo@elte.hu, tglx@linutronix.de
Subject: Re: + x86-vsmp-build-fixes.patch added to -mm tree
Message-ID: <20080318072802.GH6091@localdomain>
References: <200803180514.m2I5ElVJ015693@imap1.linux-foundation.org> <86802c440803172226yb867326rb595b36b03e6c4b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803172226yb867326rb595b36b03e6c4b9@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server54.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 10:26:55PM -0700, Yinghai Lu wrote:
>On Mon, Mar 17, 2008 at 10:14 PM,  <akpm@linux-foundation.org> wrote:
>> ...
>>  Subject: x86: vsmp build fixes
>>  From: Glauber Costa <gcosta@redhat.com>
>>
>>  VSMP depends on PCI, but the file is now compiled conditionally on PARAVIRT,
>>  no VSMP, so enclose everything in an ifdef CONFIG_PCI.

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
...
>
>in arch/x86/Kconfig
>
>config PCI
>        bool "PCI support" if !X86_VISWS && !X86_VSMP
>        depends on !X86_VOYAGER
>        default y
>        select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
>        help
>          Find out whether you have a PCI motherboard. PCI is the name of a
>          bus system, i.e. the way the CPU talks to the other stuff inside
>          your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
>          VESA. If you have PCI, say Y, otherwise N.
>
>will make sure if X86_VSMP, the PCI=y
>
>so NAK this patch.
>

Not really, as you can tell from the description Glauber provided above.

Btw, I had something similar to this cooking for the build breakage, along
with a few more updates (is_vsmp_box() is broken on vsmp).  Thanks Glauber
for this patch.

Thanks,
Kiran

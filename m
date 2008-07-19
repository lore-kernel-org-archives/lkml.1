Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbYGSEpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbYGSEpX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 00:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbYGSEpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 00:45:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:49143 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYGSEpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 00:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WCNIRV7cQUBC6+mQg6qSQAIwdItloXW0Q30qfbtp8zMfOi4JRYYBU+hbSP1HWYCUqQ
         e7EJ0m4CrSVIlapkjWeHC/FjSTL8qdv2UftoQaMu0nHf/h6i7/zFM/+XlMnZ0YlFtA+6
         a3VJiuikzPd6dB4U80KZKVVlJ5TClqPd2wDo4=
Message-ID: <86802c440807182145s58ce6cb2xfc85a6fc849a2a73@mail.gmail.com>
Date: Fri, 18 Jul 2008 21:45:08 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080719032845.GA9662@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807180941.09779.yhlu.kernel@gmail.com>
	 <20080718202118.GC24122@elte.hu>
	 <86802c440807181326l489b7763sdb040f5b6e575d8c@mail.gmail.com>
	 <20080719005849.GA9055@bromo.msbb.uc.edu>
	 <86802c440807181822l5138ff85k7d8c2e2702a11025@mail.gmail.com>
	 <20080719032845.GA9662@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 8:28 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> YH,
>   The mmconf_end_bus_num_detect.patch and mmconf_end_bus_num_detect_fix.patch both applied
> cleanly to the current linus kernel git and solve my problems with MMCONFIG not starting.
> I am attaching a dmesg log below of a boot with 'debug apic=verbose initcall_debug pci=routeirq'.
> If you look at the section immediately before the line...
>
> pci 0000:00:1e.0: transparent bridge
>
> you will see that it is radically different from what I posted for the freeze under PCIEASPM
> with MMCONFIG (using your original mmconfig patch)...

calling  pci_arch_init+0x0/0x53
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: MCFG area at f0000000 reserved in E820
PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: Using MMCONFIG at f0000000 - f3ffffff
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x53 returned 0 after 14 msecs

that mean it reduce the bus number according to e820 reserved area.

YH

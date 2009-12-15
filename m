Return-Path: <linux-kernel-owner+w=401wt.eu-S933234AbZLOSDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbZLOSDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933135AbZLOSDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:03:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:50853 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933119AbZLOSDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:03:08 -0500
Message-ID: <4B27CEF8.9010303@kernel.org>
Date: Tue, 15 Dec 2009 10:01:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Robert Hancock <hancockrwd@gmail.com>, Tvrtko Ursulin <tvrtko@ursulin.net>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Are these MTRR settings correct?
References: <200912130807.44905.tvrtko@ursulin.net> <4B26E4C7.8040100@gmail.com> <4B26E973.6080305@kernel.org> <200912150955.03974.bjorn.helgaas@hp.com>
In-Reply-To: <200912150955.03974.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Monday 14 December 2009 06:42:11 pm Yinghai Lu wrote:
>> Robert Hancock wrote:
>>> Something else isn't quite right. It looks like MMCONFIG area should be
>>> reserved:
>>>
>>> [    0.308434] system 00:0c: iomem range 0xe0000000-0xefffffff has been
>>> reserved
>>>
>>> but the code didn't seem to detect that. In fact there doesn't seem to
>>> be any output about whether it was or wasn't reserved, which from the
>>> code it seems there should be.
>>>
>>> Maybe because of that ACPI method execution error?
>> could be sth pnpacpi brokenness?
> 
> Robert, I assume you're referring to this from Tvrtko's post
> (http://lkml.org/lkml/2009/12/13/90):
> 
> [    0.000000]  BIOS-e820: 00000000dffd0000 - 00000000e0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
> ...
> [    0.250088] PCI: Found AMD Family 10h NB with MMCONFIG support.
> [    0.250091] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.250092] PCI: Not using MMCONFIG.
> ...
> [    0.253491] ACPI Error (psargs-0359): [ECEN] Namespace lookup failure, AE_NOT_FOUND
> [    0.253495] ACPI Error (psparse-0537): Method parse/execution failed [\] (Node ffffffff81656ab0), AE_NOT_FOUND
> ...
> [    0.308434] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
> 
> I think we're rejecting MMCONFIG in the early call to
> pci_mmcfg_reject_broken(), when we check only E820 resources, not
> ACPI resources.  And indeed, the 0xe0000000-0xefffffff range is
> not mentioned in E820.  Which output did you expect to see?
> 
> I am uncomfortable with this early/late checking and looking at both
> E820 and ACPI.  It just feels hacky and error-prone.  I'm not happy about
> adding Yinghai's special-case "if we found AMD Fam10h, don't check for
> reservations" patch either.

only check ACPI or remove all hostbridge detect related?


YH

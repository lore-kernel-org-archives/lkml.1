Return-Path: <linux-kernel-owner+w=401wt.eu-S1761584AbXHUQST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761584AbXHUQST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 12:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759713AbXHUQSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 12:18:05 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:4895 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbXHUQSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 12:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mO6fo162iPFSAy7jdFAKfCuKPXzAoh19VBHLccRpaMpQm/9I0iuROvPfZYsvLw9GqGXU/4EXZDYlQ+E+QqmzKlh7usFOTrZ/4ThLQxK5x4SOZm+GKwCMUw4/yIGh5zLu3UzsPu353k6tOYwqcEFbq65jxG0EE7kRWoU6iXxQLKo=
Date: Wed, 22 Aug 2007 00:17:23 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-git3 make warnings
Message-ID: <20070821161723.GA8323@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070821132038.GA22254@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821132038.GA22254@ff.dom.local>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 03:20:38PM +0200, Jarek Poplawski wrote:
>Here are some more of, probably well-known, warnings with attached
>testing-only .config.
>
>Regards,
>Jarek P.
>
>
>sed: -e expression #1, char 154: Unknown option to 's'
>drivers/acpi/ec.c: In function `acpi_ec_ecdt_probe':
>drivers/acpi/ec.c:873: warning: passing arg 1 of `acpi_get_devices' discards qualifiers from pointer target type
>drivers/pci/search.c: In function `pci_find_slot':
>drivers/pci/search.c:99: warning: `pci_find_device' is deprecated (declared at include/linux/pci.h:480)
>drivers/pci/search.c: At top level:
>drivers/pci/search.c:437: warning: `pci_find_device' is deprecated (declared at drivers/pci/search.c:244)
>drivers/pci/search.c:437: warning: `pci_find_device' is deprecated (declared at drivers/pci/search.c:244)
>drivers/pci/search.c:438: warning: `pci_find_slot' is deprecated (declared at drivers/pci/search.c:96)
>drivers/pci/search.c:438: warning: `pci_find_slot' is deprecated (declared at drivers/pci/search.c:96)
>drivers/pci/msi.c:686: warning: weak declaration of `arch_msi_check_device' after first use results in unspecified behavior
>drivers/pci/msi.c:698: warning: weak declaration of `arch_setup_msi_irqs' after first use results in unspecified behavior
>drivers/pci/msi.c:718: warning: weak declaration of `arch_teardown_msi_irqs' after first use results in unspecified behavior
>In file included from drivers/usb/host/ohci-hcd.c:859:
>drivers/usb/host/ohci-pci.c: In function `ohci_pci_start':
>drivers/usb/host/ohci-pci.c:202: warning: unused variable `pdev'
				^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This warning is suspicious. In fact, 'pdev' is used when CONFIG_PM is defined.
See the following:

<snip>
                if (device_may_wakeup(&pdev->dev))
                        ohci->hc_control |= OHCI_CTRL_RWC;
<snip>

Or a bug of gcc?

-- 
_   /|
\'o.O'
=(___)=
   U    ack!

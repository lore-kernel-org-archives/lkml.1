Return-Path: <linux-kernel-owner+w=401wt.eu-S1760500AbXHFHQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500AbXHFHQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbXHFHQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:16:07 -0400
Received: from swsoft-mipt-nat.sw.ru ([195.214.233.10]:63796 "EHLO iris"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751291AbXHFHQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:16:06 -0400
Message-ID: <46B6CAC4.3080202@sw.ru>
Date: Mon, 06 Aug 2007 11:16:20 +0400
From: "Denis V. Lunev" <den@sw.ru>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "Denis V. Lunev" <den@openvz.org>, dev@openvz.org,
       akpm@linux-foundation.org, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci_get_device call from interrupt in reboot fixups
References: <20070803103924.GA23786@iris.sw.ru> <20070804040806.GF23330@suse.de>
In-Reply-To: <20070804040806.GF23330@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Aug 03, 2007 at 02:39:24PM +0400, Denis V. Lunev wrote:
>> The following calltrace is possible now:
>>  handle_sysrq
>>    machine_emergency_restart
>>      mach_reboot_fixups
>>        pci_get_device
>>          pci_get_subsys
>> 	   down_read
>> The patch obtains PCI device during initialization to avoid bothering PCI
>> search engine in interrupt. Devices used in this code are not supposed to
>> be pluggable, so it looks safe to keep them.
> 
> What devices are supposed to be affected here?  Are you sure that they
> can't be removed later?  Grabbing references here might mess with them
> in the future.
Right now the list is the following:
static struct device_fixup fixups_table[] = {
{ PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY,
cs5530a_warm_reset },
{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA, cs5536_warm_reset },
};

Though, if the approach is not suitable, we can skip fixups if we came
from sysrq.

Regards,
	Den

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbXFYSti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbXFYSti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbXFYStb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:49:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:13456 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXFYSta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:49:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,460,1175497200"; 
   d="scan'208";a="258674778"
Message-ID: <46800E35.9030209@intel.com>
Date: Mon, 25 Jun 2007 11:49:25 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, grundler@parisc-linux.org,
       davem@davemloft.net, davej@redhat.com
Subject: Re: [PATCH 1/2] [RESEND] PCI: read revision ID by default
References: <20070625031918.4711.2705.stgit@localhost.localdomain> <20070625100109.35b4c327@the-village.bc.nu>
In-Reply-To: <20070625100109.35b4c327@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sun, 24 Jun 2007 20:19:18 -0700
> Auke Kok <auke-jan.h.kok@intel.com> wrote:
> 
>> Currently there are 97 occurrences where drivers need the pci
>> revision ID. We can do this once for all devices. Even the pci
>> subsystem needs the revision several times for quirks. The extra
>> u8 member pads out nicely in the pci_dev struct.
>>
>> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> 
> Seems worth caching yes. Care needed changing the other uses however
> that the revision isn't changeable on the hardware in some magic fashion.

if that happens the device could also change pci ID... I don't think we can 
guard against that kind of abuse anyway. While this is perfectly possible (e.g. 
network cards carrying this info in their eeproms), we should still be OK with 
the core patch, but the device driver itself needs to pull the information 
manually from the device using the pci_get_config_byte() method.

Auke

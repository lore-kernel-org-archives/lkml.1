Return-Path: <linux-kernel-owner+w=401wt.eu-S1764829AbXK3Xic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764829AbXK3Xic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764353AbXK3XiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:38:04 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:35788 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764763AbXK3XiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:38:00 -0500
Message-ID: <47509EB6.20300@keyaccess.nl>
Date: Sat, 01 Dec 2007 00:37:26 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, akpm <akpm@linux-foundation.org>,
       "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH] Declare PNP option parsing functions as __init
References: <1196442277.23251.318.camel@queen.suse.de>
In-Reply-To: <1196442277.23251.318.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-11-07 18:04, Thomas Renninger wrote:

> If I have not overseen something, it should be rather obvious that those
> can all be declared __init...
> ---------------
> 
> Declare PNP option parsing functions as __init
> 
> There are three kind of parse functions provided by PNP acpi/bios:
>  - get current resources
>  - set resources
>  - get possible resources
> The first two may be needed later at runtime.
> The possible resource settings should never change dynamically.
> And even if this would make any sense (I doubt it), the current implementation
> only parses possible resource settings at early init time:
>   -> declare all the option parsing __init
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>

Yes. Obviousness aside,

(0) pnpacpi_add_device                          is only caller of
(1)   pnpacpi_parse_resource_option_data        is only caller of
(2)     pnpacpi_option_resource                 is only caller of
(3)       pnpacpi_parse_irq_option
(3)       pnpacpi_parse_dma_option
(3)       pnpacpi_parse_port_option
(3)       pnpacpi_parse_fixed_port_option
(3)       pnpacpi_parse_mem24_option
(3)       pnpacpi_parse_mem32_option
(3)       pnpacpi_parse_fixed_mem32_option
(3)       pnpacpi_parse_address_option
(3)       pnpacpi_parse_ext_irq_option

and

(0) build_devlist                               is only caller of
(1)   insert_device                             is only caller of
(2)     pnpbios_parse_data_stream               is only caller of
(3)       pnpbios_parse_resource_option_data    is only caller of
(4)         pnpbios_parse_mem_option
(4)         pnpbios_parse_mem32_option
(4)         pnpbios_parse_fixed_mem32_option
(4)         pnpbios_parse_irq_option
(4)         pnpbios_parse_dma_option
(4)         pnpbios_parse_port_option
(4)         pnpbios_parse_fixed_port_option

which given that both (0)s are __init already, means all are fine indeed.

Acked-By: Rene Herman <rene.herman@gmail.com>

Rene.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbZBEROl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbZBEROl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZBEROa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:14:30 -0500
Received: from pmx1.sophos.com ([213.31.172.16]:54346 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbZBERO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:14:29 -0500
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Feb 2009 12:14:28 EST
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Detect mmconfig on nVidia MCP55
Date: Thu, 5 Feb 2009 17:05:32 +0000
User-Agent: KMail/1.9.10
Cc: Ed Swierk <eswierk@aristanetworks.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <1233765552.16414.6.camel@localhost.localdomain> <20090204170440.GA31973@elte.hu>
In-Reply-To: <20090204170440.GA31973@elte.hu>
MIME-Version: 1.0
Message-Id: <200902051705.33410.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 05/02/2009 17:05:33,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 05/02/2009 17:05:34,
	Serialize complete at 05/02/2009 17:05:34
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 17:04:40 Ingo Molnar wrote:
> 2) Please use vertical spaces when initializing structure fields. Instead
> of the messy looking (and over-long-line generating) construct of:
>
>         pci_mmcfg_config[0].address = (extcfg & 0x00007fff) << 25;
>         pci_mmcfg_config[0].pci_segment = 0;
>         pci_mmcfg_config[0].start_bus_number = 0;
>         pci_mmcfg_config[0].end_bus_number = (1 << (8 - ((extcfg >> 28) &
> 3))) - 1; pci_mmcfg_config_num = 1;
>
>    You will get something like:
>
>         config->address                 = (extcfg & 0x00007fff) << 25;
>         config->pci_segment             = 0;
>         config->start_bus_number        = 0;
>         config->end_bus_number          = (1 << (8 - ((extcfg >> 28) &
> 3)));
>
>         pci_mmcfg_config = config;
>         pci_mmcfg_config_num = 1;
>
>    Which makes it more structured, more reviewable - and more pleasant to
>    look at as well.

Is this in CodingStyle now? Since I have noticed you are pushing for this 
quite a lot lately. And only for structure initialisation and not also for 
example for variable declarations?

I find it a matter of personal preference whether it is more pleasant to look 
at and whether it is more or less readable.

It is also worse from diff/patch point of view since it can happen in the 
future that what would be a one line change now becomes multiline. 

Regards,

Tvrtko

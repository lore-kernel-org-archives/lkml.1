Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab0CISiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:38:08 -0500
Received: from smtp149.mail.ukl.yahoo.com ([77.238.184.80]:45338 "HELO
	smtp149.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752825Ab0CISiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:38:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ZzY5vAp8T+TXhnkJRReFZoXvNHILgdxZuHNYP4Gd6+I1XswOa0AasH8FEmmYnNU8LgwdJazZ/DZ0+0jcNOq2Bve/VpbTZxaszoUGFYyJF0zgjCAokMob4kXpt4TFTTFlf3Jxpv496yUEixV6SpHA2A8Vy09yOISmZMe+tnaohqo=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: 61Gxqa8VM1nMNXTAxcoMzRqww5WB4hV3uEsOTgw4qUA.NzwxrATWwWe3ANM9RVzA09Cv4ftsSc0AGLLnYsgQ0aJN9hn2Y8C23R83ilzIV8LU2cJ1x0wf4hFylz2ZodbT6AFFgW6sRxBWgxsB5xd03Cbx9khGBISYlRu11.yvlUNZTFbZBrUXMW7g_FIl4TBoSUPQZ0uSyqc1f.H4LDoxec9CE2uhbXEOHPzop.2UQ3aOkDwcJNceXLzy699TjwgB
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B96958B.3010403@yahoo.es>
Date: Tue, 09 Mar 2010 19:38:03 +0100
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [LKML] [RFC PATCH v3 05/11] swiotlb: add	swiotlb_set_default_size()
References: <1267963912-984-1-git-send-email-albert_herranz@yahoo.es> <1267963912-984-6-git-send-email-albert_herranz@yahoo.es> <20100308165940.GC4568@phenom.dumpdata.com>
In-Reply-To: <20100308165940.GC4568@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Sun, Mar 07, 2010 at 01:11:46PM +0100, Albert Herranz wrote:
>> The current SWIOTLB code uses a default of 64MB for the IO TLB area.
>> This size can be influenced using a kernel command line parameter "swiotlb".
>> Unfortunately, the parsing of the kernel command line is done _after_ the
>> swiotlb is initialized on some architectures.
> 
> Why can't it be moved up? I mean move the parsing of the kernel
> parameters before the PCI subsystem?

(In my case there's no PCI subsystem, this is an embedded platform without PCI support).

Currently, in the PowerPC tree a platform wanting to use the swiotlb just sets the global ppc_swiotlb_enable variable to true in its setup_arch() function.
The PowerPC setup code then calls swiotlb_init(1) just after setup_arch() when SWIOTLB and ppc_swiotlb_enable is true.
At this point the kernel command line is not yet parsed.

So, at least in PowerPC linux, the early swiotlb initialization is not influenced by the kernel command line.

Maybe switching swiotlb from __setup to early_param would help too.

>> This patch adds a new function swiotlb_set_default_size() which can be used
>> before swiotlb_init() to indicate the desired IO TLB area size in bytes.
>>
>> This will be used later to implement a smaller IO TLB on the Nintendo Wii
>> video game console which just comes with 24MB + 64MB of RAM.
> 
> Use the io_tlb_nslabs, which is what swiotlb_init_with_default_size uses
> (the passed in argument is only used if io_tlb_nslabs is not set).
> 

True, thanks.

Cheers,
Albert


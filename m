Return-Path: <linux-kernel-owner+w=401wt.eu-S1765074AbYAaH4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765074AbYAaH4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbYAaH4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:56:39 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:54646
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753822AbYAaH4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:56:38 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 1/2] IRQ_NOPROBE helper functions
Date: Thu, 31 Jan 2008 01:56:28 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
References: <200801280217.38273.rob@landley.net> <20080129111622.GC7237@linux-mips.org> <20080129112048.GA8665@linux-mips.org>
In-Reply-To: <20080129112048.GA8665@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801310156.29038.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 05:20:48 Ralf Baechle wrote:
> Probing non-ISA interrupts using the handle_percpu_irq as their handle_irq
> method may crash the system because handle_percpu_irq does not check
> IRQ_WAITING.  This for example hits the MIPS Qemu configuration.
>
> This patch provides two helper functions set_irq_noprobe and set_irq_probe
> to set rsp. clear the IRQ_NOPROBE flag.  The only current caller is MIPS
> code but this really belongs into generic code.
>
> As an aside, interrupt probing these days has become a mostly obsolete if
> not dangerous art.  I think Linux interrupts should be changed to default
> to non-probing but that's subject of this patch.
>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Acked-by: Rob Landley <rob@landley.net>

To both patches: I can confirm that applying these two fixes together avoids 
the panic for me, although I thought qemu-system-mips used to have a working 
RTC, and I can't seem to find it now.  (Make is unhappy with 1970.  It was 
not a good year for make...)

Thanks,

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

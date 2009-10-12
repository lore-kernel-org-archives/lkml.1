Return-Path: <linux-kernel-owner+w=401wt.eu-S932879AbZJLRAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbZJLRAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:00:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932874AbZJLRAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:00:01 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:16078 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873AbZJLRAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:00:00 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: increase alignment to make more space for hidden code
Date: Mon, 12 Oct 2009 10:59:09 -0600
User-Agent: KMail/1.9.10
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Ricardo Jorge da Fonseca Marques Ferreira 
	<storm@sys49152.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Yannick Roehlly <yannick.roehlly@free.fr>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, x86@kernel.org
References: <200908072333.24631.storm@sys49152.net> <4ACAC8F1.1050706@kernel.org> <4AD24B5C.4050905@kernel.org>
In-Reply-To: <4AD24B5C.4050905@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910121059.10366.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 October 2009 03:17:16 pm Yinghai Lu wrote:
> for
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13940
> 
> some system when acpi are enabled, acpi clears some BAR for some devices without
> reason, and kernel will need to allocate devices for them.

"ACPI clears some BARs"?  I'm dubious.  The handoff state is the same
whether we boot with "acpi=off" or not, so the BIOS can't be clearing
them.  I really don't think the ACPI code in Linux clears BARs.  The
Linux PCI code might be clearing BARs, but it sure would be nice to
know exactly why.  Did you ever figure that out?

> try to increase alignment to get more safe range for unassigned devices.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/e820.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/e820.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/e820.c
> +++ linux-2.6/arch/x86/kernel/e820.c
> @@ -1378,8 +1378,8 @@ static unsigned long ram_alignment(resou
>  	if (mb < 16)
>  		return 1024*1024;
>  
> -	/* To 32MB for anything above that */
> -	return 32*1024*1024;
> +	/* To 64MB for anything above that */
> +	return 64*1024*1024;

How do we know 64MB is the correct alignment?

This feels like a hack that accidentally covers up the problem.  I
don't think we understand what's happening well enough.

Bjorn

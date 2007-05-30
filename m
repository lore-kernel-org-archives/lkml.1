Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbXE3PO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbXE3PO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbXE3POA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:14:00 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42180 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbXE3PN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:13:58 -0400
Date: Wed, 30 May 2007 17:14:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ppc modprost warnings in 2.6.22-rc1
Message-ID: <20070530151424.GB15335@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0705141717110.23895@math> <20070515204540.GC22966@uranus.ravnborg.org> <Pine.SOC.4.64.0705301652250.23769@math>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0705301652250.23769@math>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 04:55:30PM +0300, Meelis Roos wrote:
> > > WARNING: arch/ppc/platforms/built-in.o - Section mismatch: reference to .init.text:Powerplus_Map_Non0 from .data between 'mot_info' (at offset 0x18) and 'Mesquite_pci_IRQ_map'
> > .....
> > 
> > mot_info is only used by functions marked __init.
> > So why not mark it __init so it get discarded and we get rid of all those warnings?
> 
> How do I mark a initialized struct __init? Adding __init or const __init in
> front of the declaration results in
> 
>   CC      arch/ppc/platforms/prep_pci.o
> arch/ppc/platforms/prep_pci.c:806: error: mot_info causes a section type conflict

>From include/linux/init.h:
 * For initialized data:
 * You should insert __initdata between the variable name and equal
 * sign followed by value, e.g.:
 *
 * static int init_variable __initdata = 0;
 * static char linux_logo[] __initdata = { 0x32, 0x36, ... };
 *
 * Don't forget to initialize data not at file scope, i.e. within a function,
 * as gcc otherwise puts the data into the bss section and not into the init
 * section.
 * 
 * Also note, that this data cannot be "const".

If you need more info we would need to update this comment.

	Sam

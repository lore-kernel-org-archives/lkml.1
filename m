Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbXKASr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbXKASr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXKASrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:47:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46185 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbXKASrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:47:18 -0400
Date: Thu, 1 Nov 2007 19:47:17 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tobias Powalowski <t.powa@gmx.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: 2.6.24 breaks nvidia and amd/ati binary drivers, by exporting
 paravirt symbols as GPL
In-Reply-To: <200711011936.33296.t.powa@gmx.de>
Message-ID: <Pine.LNX.4.64.0711011944100.24502@fbirervta.pbzchgretzou.qr>
References: <200711011936.33296.t.powa@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 1 2007 19:36, Tobias Powalowski wrote:
>Hi
>commit to .24 tree:
>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=93b1eab3d29e7ea32ee583de3362da84db06ded8
>
>introduces:
>+EXPORT_SYMBOL_GPL(pv_mmu_ops);
>+EXPORT_SYMBOL_GPL(pv_cpu_ops);
>
>pv_cpu_ops is for nvidia
>pv_mmu_ops' is for amd(ati)
>

Speaking of which, the patch introduced a strict-aliasing warning (that 
is, common userspace program compilation would warn about such) at:

+       return *((void **)&tmpl + type);

&tmpl is of type struct paravirt_patch_template **, and cross-casting 
this to void ** usually gives a strict-aliasing warning.
A workaround is to pre-cast to void *,
	return *((void **)(void *)&tmpl + type);
is that ok?

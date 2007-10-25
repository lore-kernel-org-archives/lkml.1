Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbXJYPkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbXJYPkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbXJYPkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:40:05 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51787 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbXJYPkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:40:04 -0400
Date: Thu, 25 Oct 2007 17:40:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
In-Reply-To: <20071020235546.GB1825@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0710251734190.17781@fbirervta.pbzchgretzou.qr>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Oct 21 2007, Alexey Dobriyan wrote:
>
>One of type of bugs steadily being fought is the following one:
>
>	unsigned int flags;
>	spin_lock_irqsave(&lock, flags);
>
>where "flags" should be "unsigned long". Here is far from complete list 
>of commits fixing such bugs:
>

How about making spin_lock_irqsave actually take a pointer to flags? 
(Which would be the logical choice if it were a function and not a 
macro...) That would flag up all violations ("without cast to different 
pointer" or so) while usually not breaking compilation.

Of course, irq_flags_t is probably the best long-term solution if one 
wants to hide a struct. (Even then perhaps, use a pointer instead?)

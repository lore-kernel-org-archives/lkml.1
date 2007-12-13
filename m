Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbXLMMqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbXLMMqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 07:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbXLMMqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 07:46:40 -0500
Received: from ns2.suse.de ([195.135.220.15]:56268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbXLMMqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 07:46:40 -0500
Date: Thu, 13 Dec 2007 13:46:33 +0100
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 19/19] unify set_tss_desc
Message-ID: <20071213124633.GG31699@bingen.suse.de>
References: <1197511363887-git-send-email-gcosta@redhat.com> <11975113672937-git-send-email-gcosta@redhat.com> <11975113721808-git-send-email-gcosta@redhat.com> <11975113771692-git-send-email-gcosta@redhat.com> <11975113821418-git-send-email-gcosta@redhat.com> <11975113873364-git-send-email-gcosta@redhat.com> <11975113923422-git-send-email-gcosta@redhat.com> <11975113961144-git-send-email-gcosta@redhat.com> <1197511401733-git-send-email-gc!osta@redhat.com> <11975114062948-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11975114062948-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static inline void pack_tss(tss_desc *tss, unsigned long addr,
> +			   unsigned size, unsigned entry)
> +{
> +#ifdef CONFIG_X86_64
> +		set_tssldt_descriptor(tss,
> +			     addr, entry, size);
> +#else
> +		pack_descriptor(tss, (unsigned long)addr,
> +				size,
> +				0x80 | entry, 0);

It would be better if you just unified that first instead of ifdef'ing.
I guess i386 could get a set_tssldt_descriptor() like wrapper
around pack_descriptor(). 

-Andi

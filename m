Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbYLaNdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbYLaNdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 08:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbYLaNcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 08:32:51 -0500
Received: from ozlabs.org ([203.10.76.45]:43754 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445AbYLaNcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 08:32:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel modules (take 4)
Date: Thu, 1 Jan 2009 00:02:40 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: "linux-parisc" <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
References: <4959346E.7060600@gmx.de> <200812310915.41693.rusty@rustcorp.com.au> <495B5806.3080505@gmx.de>
In-Reply-To: <495B5806.3080505@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901010002.41477.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 December 2008 22:01:18 Helge Deller wrote:
> +/* Additional bytes needed by arch in front of individual sections */
> +unsigned int arch_module_section_size(struct module *mod,
> +				      unsigned int section);
> +
...
> +/* Additional bytes needed by arch in front of individual sections */
> +unsigned int __attribute__ ((weak)) arch_module_section_size(
> +		struct module *mod, unsigned int section)
> +{
> +	/* default implementation just returns zero */
> +	return 0;
> +}

Not quite what I had in mind... let me show you:

/* Bytes needed for a section: default is just the section size. */
unsigned int __attribute__((weak))
arch_module_section_size(struct module *mod, Elf_Shdr *sechdrs, unsigned int sec)
{
	return sechdrs[sec].sh_size;
}

Otherwise I'd have called it "arch_module_extra_size()".

Cheers,
Rusty.

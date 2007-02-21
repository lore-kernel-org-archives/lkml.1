Return-Path: <linux-kernel-owner+w=401wt.eu-S1751222AbXBUL4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbXBUL4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbXBUL4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:56:48 -0500
Received: from ns2.suse.de ([195.135.220.15]:59622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbXBUL4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:56:48 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: patch to use more symbolic constants in asm
Date: Wed, 21 Feb 2007 12:56:43 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
References: <1172056242.3531.181.camel@laptopd505.fenrus.org>
In-Reply-To: <1172056242.3531.181.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702211256.43565.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 February 2007 12:10, Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: Use symbolic constants in inline assembly
> 
> This patch replaces several of the %0/%1 uses in x86-64 inline assembly
> with symbolic names (this is a new gcc 3.x feature, but that's ok now).
> This tends to, imo, make the inline assembly a lot more readable, and
> for sure it's less error prone in terms of finding which %<number>
> corresponds with which variable.

At least for two arguments i don't really see the value, but ok.

> objdump -d of the vmlinux before and after the patch is the same; also
> boot tested.

You should do i386 too then; one reason I didn't touch bitops 
for example was to keep the code more similar.


>  static inline void set_cr4(unsigned long cr4)
>  {
> -	asm volatile("mov %0,%%cr4" :: "r" (cr4) : "memory");
> +	asm volatile("mov %[cr4],%%cr4" :: [cr4] "r" (cr4) : "memory");

I'm not sure that's really an improvement for example.

-Andi

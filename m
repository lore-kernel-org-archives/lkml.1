Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYAXK3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYAXK3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 05:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYAXK3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 05:29:37 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58233 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753150AbYAXK3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 05:29:36 -0500
Date: Thu, 24 Jan 2008 11:29:11 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] define empty unxlate_dev_mem_ptr on AVR32
Message-ID: <20080124112911.0b1592f4@dhcp-252-066.norway.atmel.com>
In-Reply-To: <47972AD2.20801@niasdigital.com>
References: <47972AD2.20801@niasdigital.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008 22:53:54 +1100
Ben Nizette <bn@niasdigital.com> wrote:

>  /*
> + * We just keep an empty definition of this around (a-la the asm-generic
> + * implementation) to keep /dev/mem happy
> + */
> +#define unxlate_dev_mem_ptr(p, a) {}

Thanks, but this should be either

#define unxlate_dev_mem_ptr(p, a) do { } while (0)

or

static inline void unxlate_dev_mem_ptr(unsigned long phys, void *addr)
{
}

I prefer the latter.

Btw, the breakage was introduced by git-x86.patch. Should I take the
fix through my avr32 tree?

Haavard

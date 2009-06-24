Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbZFXCGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbZFXCGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 22:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZFXCGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 22:06:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbZFXCGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 22:06:01 -0400
Date: Tue, 23 Jun 2009 19:04:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, rgetz@blackfin.uclinux.org
Subject: Re: [PATCH 1/4] asm/sections: add text/data checking functions for
  arches to override
Message-Id: <20090623190426.d4cc9853.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0906231848u61d07a3j803f51cb26b72dab@mail.gmail.com>
References: <1245255744-21039-1-git-send-email-vapier@gentoo.org>
	<20090623154022.61e83c33.akpm@linux-foundation.org>
	<8bd0f97a0906231848u61d07a3j803f51cb26b72dab@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 21:48:03 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:

> > I suppose that for completeness and consistency etc really we should have
> >
> > #define arch_is_kernel_text arch_is_kernel_text
> > #define arch_is_kernel_data arch_is_kernel_data
> >
> > in here.
> 
> *shrug* other places that use this style dont include these defines
> for completeness

Examples?

All the ones I can find do things like

#ifndef vmcore_elf_check_arch_cross
#define vmcore_elf_check_arch_cross(x) 0
#endif

> as the define muck is for the header to know about
> (arches providing their own version), not any source code -- they
> shouldnt know anything about the ifdef stuff.

Failing to do the #define will have various tricky failure modes.  But
it's more a question of "what is the _right_ thing to do", then doing
that consistently.

>  i dont care much either way.

Someone has to.

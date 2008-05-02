Return-Path: <linux-kernel-owner+w=401wt.eu-S933981AbYEBAi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981AbYEBAi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbYEBAir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:38:47 -0400
Received: from sous-sol.org ([216.99.217.87]:56212 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbYEBAiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:38:46 -0400
Date: Thu, 1 May 2008 17:38:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Yan <rottled@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Comprehensive list of kernel self-modifications?
Message-ID: <20080502003842.GP30511@sequoia.sous-sol.org>
References: <54b90fdf0805011246v64d28c7ao8eb848419890d20a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54b90fdf0805011246v64d28c7ao8eb848419890d20a@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yan (rottled@gmail.com) wrote:
> I have been working on verifying kernel integrity and am trying to
> differentiate
> between vmlinux image on disk and the kernel loaded into memory. I understand
>  that the kernel modifies itself (on x86 at least) during at least a few points:
> 
> 
> 1. It applies alternative instructions with apply_alternatives() from
> check_bugs().
>     The locations of all alternatives are found between __alt_instructions and
>     __alt_instructions__end.

Similarly, there's apply_paravirt() for CONFIG_PARAVIRT kernels.
(Also kprobes, or anything that calls text_poke(), but I doubt it's what
you're looking for).

> 2. It also applies what looks to be relocation. I see the list of
> reloc addresses at
>     the end of vmlinux image and it appears that relocate_kernel in
> relocate_kernel.S
>     applies the relocations. I can't tell how it knows where the list
> of addresses that
>     need relocations is found. Nothing that I found points to that
> area, and the on-
>     disk data seems to live what gets mapped to as BSS when its running.

BSS?  It's not on disk outside of elf header and mapped and cleared at
startup (see clear_bss, for example).

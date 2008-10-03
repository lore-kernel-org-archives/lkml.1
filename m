Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbYJCF5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbYJCF5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 01:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYJCF5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 01:57:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:55085 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbYJCF5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 01:57:32 -0400
Date: Thu, 2 Oct 2008 22:57:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: Jakub Jelinek <jakub@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081002225718.6a0d803a@infradead.org>
In-Reply-To: <20081003052938.GS10632@outflux.net>
References: <20081001201116.GD12527@outflux.net>
	<48E3EFD6.2010704@redhat.com>
	<20081001215657.GH12527@outflux.net>
	<20081001220948.GC32107@sunsite.ms.mff.cuni.cz>
	<20081001222706.68E7E1544B4@magilla.localdomain>
	<20081003001616.GN10632@outflux.net>
	<20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com>
	<20081003052938.GS10632@outflux.net>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 22:29:38 -0700
Kees Cook <kees.cook@canonical.com> wrote:

> While discussing[1] the need for glibc to have access to random bytes
> during program load, it seems that an earlier attempt to implement
> AT_RANDOM got stalled.  This implements a configurable number of
> random bytes, as a multiple of userspace pointer size, available to
> every ELF program via a new auxv AT_RANDOM vector.


while I really like the idea of passing random bytes to glibc...
... why make it complex and configurable, rather than just always
passing, say 8 or 16 bytes.
16 bytes (say 4 vectors) is easier than "variable number of" both on the
kernel and on the glibc side, and nobody other than maybe Ulrich
and Jakub wouldn't know what to answer to the KConfig question anyway.

Or lets put it differently: why would I answer anything other than the
default? Your KConfig help text sure doesn't explain my what I give up
by answering 0 or 256....  If nobody can answer anything sensible other
than the default, it shouldn't be a config option imo.

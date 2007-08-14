Return-Path: <linux-kernel-owner+w=401wt.eu-S932533AbXHNRlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbXHNRlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762985AbXHNRkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:40:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48840 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763078AbXHNRkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:40:52 -0400
Date: Tue, 14 Aug 2007 18:48:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hajime Inoue <hinoue@ccsl.carleton.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: System call interposition/unprotecting the table
Message-ID: <20070814184816.12a8a94c@the-village.bc.nu>
In-Reply-To: <46C1E5F5.9050702@ccsl.carleton.ca>
References: <20070813180535.vo36rcevi80s0c4c@www.ccsl.carleton.ca>
	<20070814000956.7c8929dd@the-village.bc.nu>
	<46C1E5F5.9050702@ccsl.carleton.ca>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Just protecting the table does not stop rootkits.  A highly referenced
> phrack article explains how to bypass the table.  

But most people are not capable of fllowing that article - or they
wouldn't be asking here whatever their intention.

> Why isn't the rest of the kernel code protected along with the table?

Thats in progress actually and hopefully then in the hypervisor case
implementing irrevocably read-only pages.

> Finally, system call interposition is used in several interesting
> systems, most notably, systrace.  It's unclear to me how one would
> implement something like systrace without modifying the table or doing
> other rootkit-like antics.

Always wrongly. You can't be sure the table format will not change, you
can't reliably restore the table and its virtually impossible to do any
kind of trace reliably this way as you end up with two copies of the data
from user space which may vary (and leads to bad problems - see BSD
recently).


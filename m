Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbYISKeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbYISKeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYISKeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:34:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43290 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751263AbYISKeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:34:00 -0400
Date: Fri, 19 Sep 2008 11:33:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Bryan Donlan" <bdonlan@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Kernel OOPS and panic on boot in advantech watchdog init
Message-ID: <20080919113356.111ce79f@lxorguk.ukuu.org.uk>
In-Reply-To: <3e8340490809181902q31e8227fq72a7bea688b594c1@mail.gmail.com>
References: <3e8340490809181902q31e8227fq72a7bea688b594c1@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 22:02:16 -0400
"Bryan Donlan" <bdonlan@gmail.com> wrote:

> When testing a non-modular kernel on i386 with many of the default
> drivers left on under Xen, I got the following oops and panic on boot:

Looks like yet another Xen bug

> [   30.328280] BUG: unable to handle kernel paging request at d6023220
> [   30.332244] IP: [<c021f6f3>] xen_set_pte+0x3/0x10

sc520 tries to make an ioremap to read 0xfffefcb0

> [   30.332244]  [<c037be42>] ioremap_page_range+0x1e2/0x280
> [   30.332244]  [<c023d311>] __ioremap_caller+0x1e1/0x340

The Xen glue should have either permitted the mapping or failed the
ioremap attempt with NULL.

Alan

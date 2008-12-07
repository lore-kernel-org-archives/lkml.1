Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYLGLXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYLGLXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYLGLXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:23:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55930 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753481AbYLGLXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:23:33 -0500
Date: Sun, 7 Dec 2008 11:23:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510812061956g6bb422d9r7c8032fb68552b4c@mail.gmail.com>
References: <20081205193432.290a6f1a@lxorguk.ukuu.org.uk>
	<ac3eb2510812051317q79ca88e9ya876ffb94162eeca@mail.gmail.com>
	<20081205212428.GB8075@ioremap.net>
	<ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com>
	<20081206160927.GA498@ioremap.net>
	<ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com>
	<20081206165634.GA2516@ioremap.net>
	<ac3eb2510812061011u7a7f0fbdtc46b95a9c642f9c7@mail.gmail.com>
	<1228591926.3808.6.camel@nga>
	<20081206202620.GA9470@ioremap.net>
	<ac3eb2510812061956g6bb422d9r7c8032fb68552b4c@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This modprobe process does try to log an error, accesses /dev/console,
> which is not initialized in the kernel at that time, and the kernel
> module loader tries the load a module to support dev_t 5:1, which
> again runs modprobe, and ...

So we have a buggy modprobe... 

> 
> Setting CONFIG_CRYPTO_MANAGER=y makes it disapper. The patch I sent
> seems to fix it.
> 
> The bug is handled here: http://bugzilla.kernel.org/show_bug.cgi?id=12153

We cannot go re-ordering random chunks of kernel init with unpredictable
effects including possibly making other stuff less reliable (because you
set up the console device before the console driver is loaded on a PCI
bus device). And we certainly can't do it this close to a release.

Alan

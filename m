Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbZASVgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbZASVgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZASVfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:35:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53376 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752526AbZASVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:35:53 -0500
Date: Mon, 19 Jan 2009 21:31:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ide: move SFF I/O code to ide-io-sff.c
Message-ID: <20090119213101.798fe1cd@lxorguk.ukuu.org.uk>
In-Reply-To: <4974CEC5.9050402@ru.mvista.com>
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>
	<20090119130322.24745.76137.sendpatchset@localhost.localdomain>
	<49748B95.9080105@ru.mvista.com>
	<200901191523.15240.bzolnier@gmail.com>
	<49748E43.4030009@ru.mvista.com>
	<20090119173701.13fd24c6@lxorguk.ukuu.org.uk>
	<4974C030.5020509@ru.mvista.com>
	<20090119183607.5ee804e1@lxorguk.ukuu.org.uk>
	<4974CA81.1050506@ru.mvista.com>
	<20090119184951.35a52184@lxorguk.ukuu.org.uk>
	<4974CEC5.9050402@ru.mvista.com>
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

> > I'm afraid you are the one who is wrong. The IDE layer is duplicating a
> > generic level of indirection with its own code - purely because IDE
> > pre-dates that core functionality. The whole IDE layer indirection can go
> > away because Linux has caught up with the needs of the IDE layer.
> 
>     What IDE indirection you're talking about anyway?

As I said earlier ide_mm_inb etc via the function pointers tf_inb/tf_outb
etc.

Given how small those functions are it might even be worth rolling them
into two different versions of the functions like ide_tf_read as surely
it costs more to call them (in size) than to inline the two for those
functions?

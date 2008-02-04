Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYBDMjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYBDMjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYBDMje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:39:34 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53614 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752568AbYBDMjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:39:33 -0500
Date: Mon, 4 Feb 2008 13:39:25 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: michael <trimarchi@gandalf.sssup.it>, fabio@gandalf.sssup.it,
       "Andrew Victor" <linux@maxim.org.za>,
       "Chip Coldwell" <coldwell@redhat.com>,
       "Marc Pignat" <marc.pignat@hevs.ch>,
       "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Message-ID: <20080204133925.73733f5f@dhcp-252-066.norway.atmel.com>
In-Reply-To: <3efb10970801311136y12670f12x6e4fdd44de3677b9@mail.gmail.com>
References: <20080129224316.GA23155@gandalf.sssup.it>
	<479FB2D7.4020804@gandalf.sssup.it>
	<20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
	<47A051A7.7030004@gandalf.sssup.it>
	<20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>
	<47A09723.7020000@gandalf.sssup.it>
	<20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>
	<47A12A2E.5040309@gandalf.sssup.it>
	<20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>
	<3efb10970801311136y12670f12x6e4fdd44de3677b9@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 20:36:25 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> A long shot, but can it be that the ringbuffer overflows, and that
> therefor characters are lost?

That's what I was thinking too. If this is indeed the cause, the
dev_err() added by the debug patch I posted should trigger and we may
consider boosting the priority of the tasklet (using
tasklet_hi_schedule.)

Other solutions may involve trying to figure out what exactly is
blocking the tasklet from running. I have a patch series for the macb
driver that optimizes the RX processing a bit, but it obviously won't
help at91rm9200 since it uses a different driver...

Haavard

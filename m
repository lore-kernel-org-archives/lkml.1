Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbYJJO6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbYJJO6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbYJJO6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:58:08 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:57727 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757126AbYJJO6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:58:07 -0400
Date: Fri, 10 Oct 2008 16:58:14 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make ATNGW100 serial ports configurable
Message-ID: <20081010165814.1c62eabf@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <48EF6762.2080205@control.lth.se>
References: <48EF6762.2080205@control.lth.se>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Oct 2008 14:57:58.0360 (UTC) FILETIME=[955F4D80:01C92AE8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Blomdell <anders.blomdell@control.lth.se> wrote:
> Make configuration of ATNGW100 serial ports selectable in kernel configuration.
> 
> Signed-off-by: Anders Blomdell <anders.blomdell@control.lth.se>

Gak. If we're going down this path, why not add #ifdefs for every other
conceivable hardware mod as well and turn the ATNGW100 board code into
an even worse mess than the ATSTK1000 board code?

The ATNGW100 has one serial port on board, so IMO the standard board
code should only initialize that one port.

However, it might be sensible to add some sort of interface for
expansion board code. For example something like this:

#ifdef CONFIG_ATNGW100_EXPANSION
	atngw100_setup_expansion_board();
#endif

This will allow people with hardware mods to add all the extra devices
they need, including serial ports, by simply adding another file with
expansion board code. People who aren't afraid to solder stuff on their
boards shouldn't be afraid of writing some board code too, right?

What do you think?

Haavard

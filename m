Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbXEJVHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbXEJVHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761016AbXEJVHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:07:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51643
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756898AbXEJVHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:07:22 -0400
Date: Thu, 10 May 2007 14:07:25 -0700 (PDT)
Message-Id: <20070510.140725.99616053.davem@davemloft.net>
To: rmk+lkml@arm.linux.org.uk
Cc: cw@f00f.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070510205427.GF29713@flint.arm.linux.org.uk>
References: <20070510203417.GA23019@tuatara.stupidest.org>
	<20070510.135147.55726615.davem@davemloft.net>
	<20070510205427.GF29713@flint.arm.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+lkml@arm.linux.org.uk>
Date: Thu, 10 May 2007 21:54:27 +0100

> I've not had one accurate one on ARM yet.
> 
> Here's another example:
> 
> WARNING: init/built-in.o - Section mismatch: reference to .init.text:
>  from .text between 'rest_init' (at offset 0x4c) and 'run_init_process'
> 
> from init/main.c:
> 
> static void noinline rest_init(void)
>         __releases(kernel_lock)
> 
> static void run_init_process(char *init_filename)
> 
> Clearly, it just does _not_ work.

Russell, the symbols are where the reference to an .init.text
section are coming from, they are not the .init.text function
being referenced itself.

It is saying that something between rest_init and run_init_processes,
which are not .init.text, are referencing an .init.text object.

It's unfortunate that the .init.text object being referenced for some
reason can't get the symbol printed out properly on ARM, it does get
printed out on other platforms, but once you fix that it will be very
easy for you to decode these messages.

But they are still useful.

The other one you posted was legitimate and as I explained just
needs an exception entry added to modpost.c

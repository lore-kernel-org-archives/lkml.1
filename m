Return-Path: <linux-kernel-owner+w=401wt.eu-S1761069AbXE3Vtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761069AbXE3Vtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760424AbXE3Vsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:48:47 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760406AbXE3Vsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:48:46 -0400
Date: Wed, 30 May 2007 14:48:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Russell King <rmk@arm.linux.org.uk>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gerd Hoffmann <kraxel@suse.de>,
       David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 4/5] serial: convert early_uart to earlycon for 8250
Message-Id: <20070530144826.5f396d4e.akpm@linux-foundation.org>
In-Reply-To: <200705301358.54255.yinghai.lu@sun.com>
References: <200705291844.00308.yinghai.lu@sun.com>
	<465DD753.5040208@sun.com>
	<20070530131819.641e1548.akpm@linux-foundation.org>
	<200705301358.54255.yinghai.lu@sun.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 13:58:52 -0700
Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> On Wednesday 30 May 2007 13:18, Andrew Morton wrote:
> > On Wed, 30 May 2007 12:58:11 -0700
> > Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> > 
> > > >> +int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options)
> > > >> +{
> > > >> +	struct console_cmdline *c;
> > > >> +	int i;
> > > >> +
> > > >> +	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
> > > >> +		if (strcmp(console_cmdline[i].name, name) == 0 &&
> > > >> +			  console_cmdline[i].index == idx) {
> > > >> +				c = &console_cmdline[i];
> > > >> +				memcpy(c->name, name_new, sizeof(c->name));
> > > >> +				c->name[sizeof(c->name) - 1] = 0;
> > > >> +				c->options = options;
> > > >> +				c->index = idx_new;
> > > >> +				return i;
> > > >> +		}
> > > >> +	/* not found */
> > > >> +	return -1;
> > > >> +}
> > > > 
> > > > Shouldn't this be __init?
> > > > 
> > > > serial8250_find_port_for_earlycon() had its __init removed.  Why?
> > > with __init, the compiler will cry about .init.text and .text missection.
> > 
> > But was this the correct fix for that?  afaict the only caller of
> > this function is __init anyway.
> > 
> You are right.
> serial8250_find_port_for_earlycon and
> update_console_cmdline in kernel/printk.c
> could be __init

OK, please send a fixup sometime.

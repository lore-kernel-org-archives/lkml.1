Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbYCGHjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbYCGHjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 02:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYCGHj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 02:39:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751584AbYCGHj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 02:39:28 -0500
Date: Thu, 6 Mar 2008 23:38:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Daniel Walker <dwalker@mvista.com>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] Alchemy Semi Au1000 pcmcia driver: convert
 pcmcia_sockets_lock in a mutex
Message-Id: <20080306233804.4d13b637.akpm@linux-foundation.org>
In-Reply-To: <20080307071342.GE2783@traven>
References: <20080306222246.GD2783@traven>
	<1204859149.3368.2.camel@localhost.localdomain>
	<20080307071342.GE2783@traven>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 08:13:42 +0100 Matthias Kaehlcke <matthias@kaehlcke.net> wrote:

> El Thu, Mar 06, 2008 at 07:05:49PM -0800 Daniel Walker ha dit:
> 
> > On Thu, 2008-03-06 at 23:22 +0100, Matthias Kaehlcke wrote:
> > > Alchemy Semi Au1000 pcmcia driver: The semaphore pcmcia_sockets_lock
> > > is used as a mutex, convert it to the mutex API
> > > 
> > > Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
> > > 
> > 
> > This doesn't appear to be in patch format .. There no filename at the
> > top..
> 
> somehow i messed it up when adding the patch to the mail. thanks for
> the pointer, here comes the good one
> 
> -- 
> 
> Alchemy Semi Au1000 pcmcia driver: The semaphore pcmcia_sockets_lock
> is used as a mutex, convert it to the mutex API

OK.

> @@ -71,7 +72,7 @@ extern struct au1000_pcmcia_socket au1000_pcmcia_socket[];
>  u32 *pcmcia_base_vaddrs[2];
>  extern const unsigned long mips_io_port_base;
>  
> -DECLARE_MUTEX(pcmcia_sockets_lock);
> +DEFINE_MUTEX(pcmcia_sockets_lock);

I'll make this static while we're in there.



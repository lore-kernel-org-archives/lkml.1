Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbZJHNN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbZJHNN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbZJHNN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:13:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37846 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757939AbZJHNN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:13:27 -0400
Date: Thu, 8 Oct 2009 14:13:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       strakh@ispras.ru
Subject: Re: [PATCH 2/4] isicom: switch to the new tty_port_open helper
Message-ID: <20091008141353.342fd2ae@lxorguk.ukuu.org.uk>
In-Reply-To: <4ACCF5D5.7010505@gmail.com>
References: <20091007144455.14550.95003.stgit@localhost.localdomain>
	<20091007144621.14550.62068.stgit@localhost.localdomain>
	<4ACCF5D5.7010505@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Oct 2009 22:11:01 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 10/07/2009 04:46 PM, Alan Cox wrote:
> > -	if (port->port.flags & ASYNC_INITIALIZED)
> > -		return 0;
> > -	if (tty_port_alloc_xmit_buf(&port->port) < 0)
> > +	if (tty_port_alloc_xmit_buf(tport) < 0)
> 
> I think this won't work well with 1/4. ->activate is called with
> port->port.mutex (the name in this context), but tty_port_alloc_xmit_buf
> wants it again.

Ok fixed that the simple way the buffer allocator now has its own private
mutex. Any other problems strike you ?

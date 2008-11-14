Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYKNQfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYKNQfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 11:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbYKNQfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 11:35:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47048 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751037AbYKNQfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 11:35:06 -0500
Date: Fri, 14 Nov 2008 16:34:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: linux-serial@vger.kernel.org, akpm@linux-foundation.org,
       dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix an uninitialised variable warning in the 8250
 driver
Message-ID: <20081114163428.7b676742@lxorguk.ukuu.org.uk>
In-Reply-To: <20081114162038.23016.20581.stgit@warthog.procyon.org.uk>
References: <20081114162038.23016.20581.stgit@warthog.procyon.org.uk>
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

On Fri, 14 Nov 2008 16:20:38 +0000
David Howells <dhowells@redhat.com> wrote:

> Fix an uninitialised variable warning in the 8250 driver:
> 
>   CC      drivers/serial/8250.o
> drivers/serial/8250.c: In function 'serial8250_shutdown':
> drivers/serial/8250.c:1612: warning: 'i' may be used uninitialized in this function

Current versions of gcc that I've tested get this all correct just fine
for x86 at least.

Do check that the BUG_ON() helper for whatever platform you are using
needs to correctly indicate that its BUG spewing path may not return
(__attibute((__noreturn__)). I seem to remember some of the architectures
are broken on that.

Alan

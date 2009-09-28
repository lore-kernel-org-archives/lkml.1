Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbZI1PYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbZI1PYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 11:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZI1PYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 11:24:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52809 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752080AbZI1PYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 11:24:31 -0400
Date: Mon, 28 Sep 2009 16:25:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove pty_ops_bsd and pty_bsd_ioctl() as they're not
 used
Message-ID: <20090928162508.195fb08e@lxorguk.ukuu.org.uk>
In-Reply-To: <7306.1254149744@redhat.com>
References: <20090928151628.62955233@lxorguk.ukuu.org.uk>
	<20090928135332.4300.56046.stgit@warthog.procyon.org.uk>
	<7306.1254149744@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 15:55:44 +0100
David Howells <dhowells@redhat.com> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > Possibly legacy_pty_init() should be passing this to tty_set_operations()
> > > rather than pty_ops.
> > 
> > It should indeed, otherwise the BSD pty locking ioctl fails.
> 
> In that case, what should be using pty_ops?  If CONFIG_LEGACY_PTYS=n, then I
> see:
> 
> 	drivers/char/pty.c:314: warning: unused variable `pty_ops'

You'd have to go and check the old code but I believe one side of the BSD
pair uses pty_ops the other pty_bsd ops, and unix98 uses different ops
again.

All it does is make sure the right ioctls appear on the right devices.
Quite why the can't all use one and a simple if in the ioctl handler I'm
not sure

